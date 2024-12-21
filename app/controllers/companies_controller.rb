# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show]

  # GET /companies or /companies.json
  def index
    @companies = Company.includes(
      :job_posts,
      :company_size,
      :ats_type,
      :funding_type,
      :company_type,
      :company_cities,
      :company_states,
      :company_countries,
      :company_specializations,
      :company_domains,
      :healthcare_domains
    )

    @companies = apply_filters(@companies)

    render json: @companies.as_json(
      include: {
        job_posts: { only: %i[job_title job_description job_active] },
        company_size: { only: [:size_range] },
        ats_type: { only: [:ats_type_name] },
        funding_type: { only: [:name] },
        company_type: { only: [:name] },
        company_cities: { include: { city: { only: [:city_name] } } },
        company_states: { include: { state: { only: [:state_name] } } },
        company_countries: { include: { country: { only: [:country_name] } } },
        company_specializations: { include: { company_specialty: { only: %i[key value] } } },
        company_domains: { include: { healthcare_domain: { only: %i[key value] } } },
        healthcare_domains: { only: %i[key value] }
      },
      methods: [:logo_url]
    )
  end

  # GET /companies/1 or /companies/1.json
  def show
    @company = Company.includes(
      :job_posts,
      :company_size,
      :ats_type,
      :funding_type,
      :company_type,
      :company_cities,
      :company_states,
      :company_countries,
      :company_specializations,
      :company_domains,
      :healthcare_domains
    ).find(params[:id])

    # Add human-readable values for associated models
    render json: @company.as_json(
      include: {
        job_posts: { only: %i[job_title job_description job_active] },
        company_size: { only: [:size_range] },
        ats_type: { only: [:ats_type_name] },
        funding_type: { only: [:name] },
        company_type: { only: [:name] },
        company_cities: { include: { city: { only: [:city_name] } } },
        company_states: { include: { state: { only: [:state_name] } } },
        company_countries: { include: { country: { only: [:country_name] } } },
        company_specializations: { include: { company_specialty: { only: %i[key value] } } },
        company_domains: { include: { healthcare_domain: { only: %i[key value] } } },
        healthcare_domains: { only: %i[key value] }
      },
      methods: [:logo_url]
    )
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Company not found' }, status: :not_found
  end
end

# GET /companies/new
def new
  @company = Company.new
end

  private

# Use callbacks to share common setup or constraints between actions.
def set_company
  @company = Company.find(params[:id])
end

def apply_filters(companies)
  if params[:domain_id].present?
    companies = companies.joins(:healthcare_domains).where(healthcare_domains: { id: params[:domain_id] })
  end
  if params[:company_size_id].present?
    companies = companies.where(company_size_id: params[:company_size_id])
  end
  if params[:operating_status].present?
    companies = companies.where(operating_status: params[:operating_status])
  end
  if params[:funding_type_id].present?
    companies = companies.where(funding_type_id: params[:funding_type_id])
  end
  companies = companies.where(year_founded: params[:year_founded]) if params[:year_founded].present?
  if params[:company_description].present?
    companies = companies.where('company_description ILIKE ?',
                                "%#{params[:company_description]}%")
  end
  if params[:company_tagline].present?
    companies = companies.where('company_tagline ILIKE ?',
                                "%#{params[:company_tagline]}%")
  end
  if params[:is_completely_remote].present?
    companies = companies.where(is_completely_remote: params[:is_completely_remote])
  end

  # Filter by associated models
  if params[:city_id].present?
    companies = companies.joins(:company_cities).where(company_cities: { city_id: params[:city_id] })
  end

  if params[:country_id].present?
    companies = companies.joins(:company_countries).where(company_countries: { country_id: params[:country_id] })
  end

  if params[:state_id].present?
    companies = companies.joins(:company_states).where(company_states: { state_id: params[:state_id] })
  end

  if params[:specialization_id].present?
    companies = companies.joins(:company_specializations).where(company_specializations: { company_specialty_id: params[:specialization_id] })
  end

  companies
end

# Only allow a list of trusted parameters through.
def company_params
  params.require(:company).permit(
    :company_name,
    :operating_status,
    :company_size_id,
    :ats_type_id,
    :funding_type_id,
    :linkedin_url,
    :company_url,
    :company_type_id,
    :is_public,
    :year_founded,
    :city_id,
    :state_id,
    :country_id,
    :acquired_by,
    :company_description,
    :ats_id,
    :logo_url,
    :company_tagline,
    :is_completely_remote,
    :error_details,
    :reference_id,
    :resolved,
    company_specialization_ids: [],
    healthcare_domain_ids: [],
    company_city_ids: [],
    company_state_ids: [],
    company_country_ids: []
  )
end
