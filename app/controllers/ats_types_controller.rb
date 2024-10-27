class AtsTypesController < ApplicationController
    def index
      ats_types = AtsType.select(:ats_type_code, :ats_type_name)
      render json: ats_types
    end
  end