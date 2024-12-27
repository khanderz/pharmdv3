# frozen_string_literal: true

class MembershipType < ApplicationRecord
    has_many :users
  
    validates :name, presence: true, uniqueness: true
    validates :price, numericality: { greater_than_or_equal_to: 0 }
    validates :duration, numericality: { only_integer: true, greater_than: 0 }
  end