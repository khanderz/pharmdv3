# frozen_string_literal: true

class HealthcareDomainsController < ApplicationController
  def index
    healthcare_domains = HealthcareDomain.all
    render json: healthcare_domains
  end
end
