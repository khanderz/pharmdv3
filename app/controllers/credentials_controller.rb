class CredentialsController < ApplicationController
    def index
      @credentials = Credential.all
      render json: @credentials
    end
end
