# frozen_string_literal: true

class AtsTypesController < ApplicationController
  def index
    ats_types = AtsType.select(:id, :ats_type_code, :ats_type_name, :domain_matched_url, :redirect_url, :post_match_url)
    render json: ats_types
  end
end
