# frozen_string_literal: true

class CompanySizeSerializer < ActiveModel::Serializer
  attributes :id, :size_range_code, :size_range_name
end
