# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show edit update destroy]

  # GET /companies or /companies.json
  def index
    # Check if a domain filter is applied
    if params[:domain_id].present?
      # Filter companies that have the selected healthcare domain
      @companies = Company.joins(:healthcare_domains)
                          .where(healthcare_domains: { id: params[:domain_id] })
                          .includes(:job_posts, :company_size, :ats_type, :country, :state, :city, :company_specialties, :healthcare_domains)
    else
      # No filter applied, return all companies
      @companies = Company.includes(:job_posts, :company_size, :ats_type, :country, :state, :city, :company_specialties,
                                    :healthcare_domains).all
    end

    # Render JSON with nested relationships
    render json: @companies.as_json(
      include: {
        job_posts: { only: %i[job_title job_description job_active] },
        company_size: { only: [:size_range] },
        ats_type: { only: [:ats_type_name] },
        country: { only: [:country_name] },
        state: { only: [:state_name] },
        city: { only: [:city_name] },
        company_specialties: { only: %i[key value] },
        healthcare_domains: { only: %i[key value] }
      }
    )
  end

  # GET /companies/1 or /companies/1.json
  def show
    @company = Company.includes(
      :job_posts,
      :company_size,
      :ats_type,
      :country,
      :state,
      :city,
      :company_specialties,
      :healthcare_domains # Include healthcare domains
    ).find(params[:id])

    # Add human-readable values for associated models
    company_with_details = @company.as_json(
      include: {
        job_posts: { only: %i[job_title job_description job_active] },
        company_size: { only: [:size_range] },
        ats_type: { only: [:ats_type_name] },
        country: { only: [:country_name] },
        state: { only: [:state_name] },
        city: { only: [:city_name] },
        company_specialties: { only: %i[key value] },
        healthcare_domains: { only: %i[key value] } # Include healthcare domain details
      }
    )

    render json: company_with_details
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit; end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to company_url(@company), notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1 or /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to company_url(@company), notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1 or /companies/1.json
  def destroy
    @company.destroy!

    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
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
      :linkedin_url,
      :is_public,
      :year_founded,
      :city_id,
      :state_id,
      :country_id,
      :acquired_by,
      :company_description,
      :ats_id,
      company_specialization_ids: [],   # Allow for company specializations
      healthcare_domain_ids: []         # Allow for healthcare domain associations
    )
  end
end
