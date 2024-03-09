require "application_system_test_case"

class CompaniesTest < ApplicationSystemTestCase
  setup do
    @company = companies(:one)
  end

  test "visiting the index" do
    visit companies_url
    assert_selector "h1", text: "Companies"
  end

  test "should create company" do
    visit companies_url
    click_on "New company"

    fill_in "Acquired by", with: @company.acquired_by
    fill_in "Ats", with: @company.ats_id
    fill_in "Company ats type", with: @company.company_ats_type
    fill_in "Company city", with: @company.company_city
    fill_in "Company country", with: @company.company_country
    fill_in "Company name", with: @company.company_name
    fill_in "Company size", with: @company.company_size
    fill_in "Company state", with: @company.company_state
    fill_in "Company type", with: @company.company_type
    check "Is public" if @company.is_public
    fill_in "Last funding type", with: @company.last_funding_type
    fill_in "Linkedin url", with: @company.linkedin_url
    check "Operating status" if @company.operating_status
    fill_in "Year founded", with: @company.year_founded
    click_on "Create Company"

    assert_text "Company was successfully created"
    click_on "Back"
  end

  test "should update Company" do
    visit company_url(@company)
    click_on "Edit this company", match: :first

    fill_in "Acquired by", with: @company.acquired_by
    fill_in "Ats", with: @company.ats_id
    fill_in "Company ats type", with: @company.company_ats_type
    fill_in "Company city", with: @company.company_city
    fill_in "Company country", with: @company.company_country
    fill_in "Company name", with: @company.company_name
    fill_in "Company size", with: @company.company_size
    fill_in "Company state", with: @company.company_state
    fill_in "Company type", with: @company.company_type
    check "Is public" if @company.is_public
    fill_in "Last funding type", with: @company.last_funding_type
    fill_in "Linkedin url", with: @company.linkedin_url
    check "Operating status" if @company.operating_status
    fill_in "Year founded", with: @company.year_founded
    click_on "Update Company"

    assert_text "Company was successfully updated"
    click_on "Back"
  end

  test "should destroy Company" do
    visit company_url(@company)
    click_on "Destroy this company", match: :first

    assert_text "Company was successfully destroyed"
  end
end
