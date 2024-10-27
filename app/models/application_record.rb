# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # def initialize(*)
  #   super
  # rescue ArgumentError
  #   raise if valid?
  # end
end
