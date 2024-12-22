# frozen_string_literal: true

class JobPostsController < ApplicationController
  before_action :set_job_post, only: %i[show edit update destroy]

  def index
    if params[:domain_ids].present?
      domain_ids = params[:domain_ids]
      @job_posts = JobPost.joins(company: :healthcare_domains)
                          .where('healthcare_domains.id IN (?)', domain_ids)
                          .includes(
                            :job_post_benefits,
                            :job_post_cities,
                            :job_post_countries,
                            :job_post_credentials,
                            :job_post_educations,
                            :job_post_experiences,
                            :job_post_seniorities,
                            :job_post_skills,
                            :job_post_states,
                            company: [
                              :company_specialties,
                              { company_domains: :healthcare_domain }
                            ]
                          )
    else
      @job_posts = JobPost.includes(
        :job_post_benefits,
        :job_post_cities,
        :job_post_countries,
        :job_post_credentials,
        :job_post_educations,
        :job_post_experiences,
        :job_post_seniorities,
        :job_post_skills,
        :job_post_states,
        company: [
          :company_specialties,
          { company_domains: :healthcare_domain }
        ]
      ).all
    end
  
    if params[:salary_min].present?
      @job_posts = @job_posts.where('job_salary_min >= ?', params[:salary_min])
    end
    if params[:salary_max].present?
      @job_posts = @job_posts.where('job_salary_max <= ?', params[:salary_max])
    end
    if params[:job_salary_currency_id].present?
      @job_posts = @job_posts.where(job_salary_currency_id: params[:job_salary_currency_id])
    end
  
    render json: @job_posts.as_json(
      include: {
        job_post_benefits: { only: [:id, :benefit_id] },
        job_post_cities: { only: [:id, :city_id] },
        job_post_countries: { only: [:id, :country_id] },
        job_post_credentials: { only: [:id, :credential_id] },
        job_post_educations: { only: [:id, :education_id] },
        job_post_experiences: { only: [:id, :experience_id] },
        job_post_seniorities: { only: [:id, :job_seniority_id] },
        job_post_skills: { only: [:id, :skill_id] },
        job_post_states: { only: [:id, :state_id] },
        company: {
          include: {
            company_specialties: {},
            company_domains: { include: :healthcare_domain }
          }
        }
      }
    )
  end
  
  def show
    render json: @job_post.as_json(
      include: {
        job_post_benefits: { only: [:id, :benefit_id] },
        job_post_cities: { only: [:id, :city_id] },
        job_post_countries: { only: [:id, :country_id] },
        job_post_credentials: { only: [:id, :credential_id] },
        job_post_educations: { only: [:id, :education_id] },
        job_post_experiences: { only: [:id, :experience_id] },
        job_post_seniorities: { only: [:id, :job_seniority_id] },
        job_post_skills: { only: [:id, :skill_id] },
        job_post_states: { only: [:id, :state_id] },
        company: {
          include: {
            company_specialties: {},
            company_domains: { include: :healthcare_domain }
          }
        }
      }
    )
  end  

  # GET /job_posts/1/edit
  def edit; end

  # POST /job_posts or /job_posts.json
  def create
    @job_post = JobPost.new(job_post_params)

    respond_to do |format|
      if @job_post.save
        format.html { redirect_to @job_post, notice: 'Job post was successfully created.' }
        format.json { render :show, status: :created, location: @job_post }
      else
        format.html { render :new }
        format.json { render json: @job_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_posts/1 or /job_posts/1.json
  def update
    respond_to do |format|
      if @job_post.update(job_post_params)
        format.html { redirect_to @job_post, notice: 'Job post was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_post }
      else
        format.html { render :edit }
        format.json { render json: @job_post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /job_posts/1 or /job_posts/1.json
  def destroy
    @job_post.destroy
    respond_to do |format|
      format.html { redirect_to job_posts_url, notice: 'Job post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_job_post
    @job_post = JobPost.find(params[:id])
  end

  def job_post_params
    params.require(:job_post).permit(
      :job_title, :job_description, :job_url, :job_salary_min,
      :job_salary_max, :job_salary_currency_id,
      :job_posted, :job_updated, :job_active,
      :department_id, :country_id, :team_id, :job_role_id,
      :job_commitment_id, :job_setting_id, :company_id
    )
  end
end
