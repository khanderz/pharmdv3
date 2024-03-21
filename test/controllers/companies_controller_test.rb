require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:one)
  end

  test "should get index" do
    get companies_url
    assert_response :success
  end

  test "should get new" do
    get new_company_url
    assert_response :success
  end

  test "should create company" do
    assert_difference("Company.count") do
      post companies_url, params: { company: { acquired_by: @company.acquired_by, ats_id: @company.ats_id, company_ats_type: @company.company_ats_type, company_city: @company.company_city, company_country: @company.company_country, company_name: @company.company_name, company_size: @company.company_size, company_state: @company.company_state, company_type: @company.company_type, company_type_value: @company.company_type_value, is_public: @company.is_public, last_funding_type: @company.last_funding_type, linkedin_url: @company.linkedin_url, operating_status: @company.operating_status, year_founded: @company.year_founded } }
    end

    assert_redirected_to company_url(Company.last)
  end

  test "should show company" do
    get company_url(@company)
    assert_response :success
  end

  test "should get edit" do
    get edit_company_url(@company)
    assert_response :success
  end

  test "should update company" do
    patch company_url(@company), params: { company: { acquired_by: @company.acquired_by, ats_id: @company.ats_id, company_ats_type: @company.company_ats_type, company_city: @company.company_city, company_country: @company.company_country, company_name: @company.company_name, company_size: @company.company_size, company_state: @company.company_state, company_type: @company.company_type, company_type_value: @company.company_type_value, is_public: @company.is_public, last_funding_type: @company.last_funding_type, linkedin_url: @company.linkedin_url, operating_status: @company.operating_status, year_founded: @company.year_founded } }
    assert_redirected_to company_url(@company)
  end

  test "should destroy company" do
    assert_difference("Company.count", -1) do
      delete company_url(@company)
    end

    assert_redirected_to companies_url
  end
end
