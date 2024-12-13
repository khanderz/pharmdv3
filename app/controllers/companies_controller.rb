# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show ]

  # GET /companies or /companies.json
  def index
    # Check if a domain filter is applied
    if params[:domain_id].present?
      # Filter companies that have the selected healthcare domain
      @companies = Company.joins(:healthcare_domains)
                          .where(healthcare_domains: { id: params[:domain_id] })
                          .includes(
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
    else
      # No filter applied, return all companies
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
      ).all
    end

    # Render JSON with nested relationships
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

