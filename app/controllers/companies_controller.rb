class CompaniesController < ApplicationController
  before_action :set_company, only: %i[ show edit update destroy ]

  # GET /companies or /companies.json
  def index
    # Check if `company_type` is passed in the query params
    if params[:company_type]
      @companies = Company.where(company_type: params[:company_type])
                          .includes(:job_posts, :company_type, :company_specialties)
    else
      @companies = Company.includes(:job_posts, :company_type, :company_specialties).all
    end
    
    render json: @companies.as_json(include: [:job_posts, :company_type, { company_specialties: { only: [:key, :value] } }])
  end
  
# GET /companies/1 or /companies/1.json
def show
  @company = Company.includes(:job_posts, :company_type, :company_specialties).find(params[:id])

  # Add human-readable values for the enum fields
  company_with_enums = @company.as_json(include: [:job_posts, { company_specialties: { only: [:key, :value] } }]).merge(
    company_type: @company.company_type.name, # Assuming company_type has a `name` attribute
    pharmacy_type: @company.pharmacy_type.present? ? Company::PHARMACY_TYPES[@company.pharmacy_type] : nil,
    digital_health_type: @company.digital_health_type.present? ? Company::DIGITAL_HEALTH_TYPES[@company.digital_health_type] : nil
  )

  render json: company_with_enums
end


  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies or /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to company_url(@company), notice: "Company was successfully created." }
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
        format.html { redirect_to company_url(@company), notice: "Company was successfully updated." }
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
      format.html { redirect_to companies_url, notice: "Company was successfully destroyed." }
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
      :company_type, 
      :pharmacy_type, 
      :digital_health_type, 
      :company_ats_type, 
      :company_size, 
      :last_funding_type, 
      :linkedin_url, 
      :is_public, 
      :year_founded, 
      :company_city, 
      :company_state, 
      :company_country, 
      :acquired_by, 
      :ats_id
    )
  end
end
