class HealthcareDomainsController < ApplicationController
    def index
        healthcare_domains = HealthcareDomain.pluck(:value)
        render json: healthcare_domains
    end
end
