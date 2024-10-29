class JobPost < ApplicationRecord
  has_paper_trail

  has_many :adjudications, as: :adjudicatable, dependent: :destroy
  has_many :job_post_cities, dependent: :destroy
  has_many :cities, through: :job_post_cities
  has_many :job_post_states, dependent: :destroy
  has_many :states, through: :job_post_states
  has_many :job_post_countries, dependent: :destroy
  has_many :countries, through: :job_post_countries

  belongs_to :job_commitment, optional: true
  belongs_to :job_setting
  belongs_to :department
  belongs_to :team
  belongs_to :company
  belongs_to :job_role
  belongs_to :job_salary_currency, optional: true
  belongs_to :job_salary_interval, optional: true

  validates :job_title, presence: true
  validates :job_url, uniqueness: true
  validates :job_salary_min, :job_salary_max, numericality: { greater_than_or_equal_to: 0 },
                                              allow_nil: true

  # Shared methods -----------------------------------------------------------
  def self.deactivate_old_jobs(company, active_job_ids)
    deactivated_count = JobPost.where(company: company).where.not(id: active_job_ids).update_all(job_active: false)
    puts "Deactivated #{deactivated_count} old job posts for #{company.company_name}"
  end

  def self.process_existing_or_new_job(company, job_url, job_post_data, locations)
    existing_job = JobPost.find_by(job_url: job_url)
    if existing_job
      if existing_job.attributes.except('id', 'created_at', 'updated_at') == job_post_data
        puts "Job post already exists and is unchanged for URL: #{job_url}"
      else
        existing_job.update(job_post_data)
        update_job_locations(existing_job, locations)
        puts "Updated job post for URL: #{job_url}"
      end
      existing_job.id
    else
      new_job_post = JobPost.new(job_post_data)
      if new_job_post.save
        puts "#{company.company_name} job post added"
        update_job_locations(new_job_post, locations)
        new_job_post.id
      else
        Adjudication.create!(
          adjudicatable_type: 'JobPost',
          adjudicatable_id: new_job_post.id,
          error_details: new_job_post.errors.full_messages.join(', '),
          resolved: false
        )
        puts "Error saving job post for #{company.company_name} - #{new_job_post.errors.full_messages.join(', ')}"
        nil
      end
    end
  end

  def self.update_job_locations(job_post, locations)
    job_post.countries = locations[:countries] if locations[:countries]
    job_post.states = locations[:states] if locations[:states]
    job_post.cities = locations[:cities] if locations[:cities]
  end

  def self.get_job_url(ats_code, job)
    case ats_code
    when 'LEVER'
      job['hostedUrl']
    when 'GREENHOUSE'
      job['absolute_url']
    end
  end

  private

  def self.fetch_jobs(company)
    jobs = get_jobs(company)
    ats_code = company.ats_type.ats_type_code
    if ats_code == 'LEVER'
      if jobs.present?
        active_job_ids = save_jobs(ats_code, company, jobs)
        deactivate_old_jobs(company, active_job_ids)
      end
    elsif ats_code == 'GREENHOUSE'
      if jobs && jobs['jobs']
        jobs_mapped = jobs['jobs'].map { |job| job }
        active_job_ids = save_jobs(ats_code, company, jobs_mapped)
        deactivate_old_jobs(company, active_job_ids)
      else
        puts "No jobs found for #{company.company_name}"
      end
    else
      puts "ATS type #{ats_code} not supported for company: #{company.company_name}"
    end
  end

  def self.get_jobs(company)
    if company.ats_type.ats_type_code == 'LEVER'
      company_name = company.company_name.gsub(' ', '').downcase
      url = "https://api.lever.co/v0/postings/#{company_name}"
      uri = URI(url)

      begin
        response = Net::HTTP.get(uri)
        jobs = JSON.parse(response)

        return jobs if jobs.is_a?(Array)

        company.error_details = 'failed to fetch Lever jobs'
        company.resolved = false
        company.save!

        Adjudication.create!(
          adjudicatable_type: 'Company',
          adjudicatable_id: company.id,
          error_details: "failed to fetch Lever jobs for #{company.company_name}",
          resolved: false
        )
        puts "Error: #{jobs['message']}, cannot get Lever jobs. Logged to adjudications."

        nil
      rescue StandardError => e
        error_message = "Exception occurred while fetching Lever jobs for #{company.company_name}: #{e.message}"
        puts error_message

        Adjudication.create!(
          adjudicatable_type: 'Company',
          adjudicatable_id: company.id,
          error_details: error_message,
          resolved: false
        )

        nil
      end
    elsif company.ats_type.ats_type_code == 'GREENHOUSE'
      ats_id = company.ats_id
      puts "Fetching Greenhouse jobs for company: #{company.company_name}"
      url = "https://boards-api.greenhouse.io/v1/boards/#{ats_id}/jobs?content=true"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      jobs = JSON.parse(response)

      return jobs if jobs.is_a?(Hash)

      company.error_details = 'failed to fetch Greenhouse jobs'
      company.resolved = false
      company.save!

      Adjudication.create!(
        adjudicatable_type: 'Company',
        adjudicatable_id: company.id,
        error_details: "failed to fetch Greenhouse jobs for #{company.company_name}",
        resolved: false
      )
      puts "Error: #{jobs['message']}, cannot get Greenhouse jobs. Logged to adjudications."

      nil
    else
      puts "ATS type #{company.ats_type.ats_type_code} not supported for company: #{company.company_name}"
    end
  end

  def self.get_job_role_params(ats_code, job)
    case ats_code
    when 'LEVER'
      [job['text'], Array(job['categories']['department']), Array(job['categories']['team'])]
    when 'GREENHOUSE'
      department_names = job['departments'].map { |dept| dept['name'] }
      team_names = department_names
      [job['title'], department_names, team_names]
    else
      puts "ATS type #{ats_code} not supported"
    end
  end

  def self.save_jobs(ats_code, company, jobs)
    active_job_ids = []
    job_count = 0
    build_count = 0
    jobs.each do |job|
      job_role_params = get_job_role_params(ats_code, job)
      role_name, department_names, team_names = job_role_params
      job_role = JobRole.find_or_create_with_department_and_team(role_name, department_names,
                                                                 team_names)
      job_url = get_job_url(ats_code, job)

      mapped_data = map_ats_data_return(ats_code, job, company)
      job_count += 1

      job_post_data = build_job_post_data(company, mapped_data, job_role)
      build_count += 1

      active_job_ids << process_existing_or_new_job(company, job_url, job_post_data)
    end
    puts "Mapped #{job_count} jobs from #{ats_code}"
    puts "Built #{build_count} job posts"
    active_job_ids
  end

  def self.map_ats_data_return(ats, job, company)
    if ats == 'LEVER'
      {
        job_title: job['text'],
        department_id: Department.find_department(job['categories']['department'], 'JobPost',
                                                  job['hostedUrl']).id,
        team_id: Team.find_or_create_by(team_name: job['categories']['team']).id,
        job_setting_id: find_setting_id_by_name(job['workplaceType']),
        job_description: job['descriptionBodyPlain'],
        job_url: job['hostedUrl'],
        job_additional: job['additionalPlain'],
        job_commitment_id: find_commitment_id_by_name(job['categories']['commitment']),
        job_locations: job['categories']['allLocations'],
        job_posted: Time.at(job['createdAt'] / 1000).strftime('%Y-%m-%d'),
        job_internal_id_string: job['id'],
        job_applyUrl: job['applyUrl'],
        job_salary_max: job['salaryRange'] ? job['salaryRange']['max'] : nil,
        job_salary_min: job['salaryRange'] ? job['salaryRange']['min'] : nil,
        job_salary_currency_id: handle_currency_record(job['salaryRange']&.dig('currency'),
                                                       company.id, job['hostedUrl']),
        job_salary_interval_id: find_interval_id_by_name(job['salaryRange']&.dig('interval'))
      }
    elsif ats == 'GREENHOUSE'
      location_info = parse_location(job['location']['name'])
      job_setting_id = find_job_setting_by_location(location_info[:location],
                                                    location_info[:is_remote])
      {
        job_title: job['title'],
        department_id: Department.find_department(job['departments'][0]['name'], 'JobPost',
                                                  job['absolute_url']).id,
        team_id: Team.find_or_create_by(team_name: job['departments'][0]['name']).id,
        job_setting_id: job_setting_id,
        job_description: job['content'],
        job_url: job['absolute_url'],
        job_applyUrl: job['absolute_url'],
        job_locations: location_info[:location],
        job_posted: job.is_a?(Hash) && job.key?('created_at') ? job['created_at'] : nil,
        job_updated: Time.parse(job['updated_at']).strftime('%Y-%m-%d %H:%M:%S'),
        job_internal_id: job['internal_job_id'],
        job_url_id: job['id'],
        job_internal_id_string: job.is_a?(Hash) && job.key?('internal_job_id') ? job['internal_job_id'].to_s : nil,
        job_salary_max: job['salaryRange'] ? job['salaryRange']['max'] : nil,
        job_salary_min: job['salaryRange'] ? job['salaryRange']['min'] : nil,
        job_salary_currency_id: handle_currency_record(job['salaryRange']&.dig('currency'),
                                                       company.id, job['absolute_url']),
        job_salary_interval_id: find_interval_id_by_name(job['salaryRange']&.dig('interval'))
      }
    end
  end

  def self.build_job_post_data(company, data, job_role)
    data.merge({
                 company_id: company.id,
                 job_active: true,
                 job_role: job_role
               })
  end

  # Helper methods
  def self.handle_country_record(country_code, country_name, company_id, job_url)
    Country.find_or_adjudicate_country(country_code, country_name, company_id, job_url)
  end

  def self.parse_location(location_name)
    states = State.pluck(:state_code, :state_name).to_h
    cities = City.pluck(:city_name, :aliases).map do |name, aliases|
      [name, aliases || []].flatten
    end.flatten
    location = location_name
    is_remote = false
    if location_name.downcase.include?('or')
      location = location.gsub(/\sor.*/i, '')
      is_remote = true
    end

    state_match = states.keys.find do |code|
      location.include?(code)
    end || states.values.find do |name|
             location.include?(name)
           end
    city_match = cities.find { |city| location.include?(city) }
    is_remote = false if state_match || city_match
    { location: location, is_remote: is_remote }
  end

  def self.find_job_setting_by_location(location, is_remote)
    if is_remote
      find_setting_id_by_name('Remote')
    elsif location.present?
      find_setting_id_by_name('On-site')
    else
      nil
    end
  end

  def self.find_setting_id_by_name(setting_name)
    return nil if setting_name.nil?

    JobSetting.where('LOWER(setting_name) = ? OR LOWER(?) = ANY (SELECT LOWER(unnest(aliases)))',
                     setting_name.downcase, setting_name.downcase).first&.id
  end

  def self.find_commitment_id_by_name(commitment_name)
    JobCommitment.find_by(commitment_name: commitment_name)&.id
  end

  def self.handle_currency_record(currency_code, company_id, job_url)
    JobSalaryCurrency.find_or_adjudicate_currency(currency_code, company_id, job_url)&.id
  end

  def self.find_interval_id_by_name(interval_name)
    JobSalaryInterval.find_by(interval: interval_name)&.id
  end
end
