# frozen_string_literal: true

class JobCommitmentsController < ApplicationController
  def index
    @job_commitments = JobCommitment.all
    render json: @job_commitments
  end
end
