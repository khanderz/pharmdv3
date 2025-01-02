# frozen_string_literal: true

FactoryBot.define do
  factory :department do
    dept_name { 'Default Department' }

    trait :business_development do
      dept_name { 'Business Development' }
    end

    trait :clinical_team do
      dept_name { 'Clinical Team' }
    end

    trait :customer_support do
      dept_name { 'Customer Support' }
    end

    trait :data_science do
      dept_name { 'Data Science' }
    end

    trait :design do
      dept_name { 'Design' }
    end

    trait :editorial do
      dept_name { 'Editorial' }
    end

    trait :engineering do
      dept_name { 'Engineering' }
    end

    trait :executive do
      dept_name { 'Executive' }
    end

    trait :finance do
      dept_name { 'Finance' }
    end

    trait :human_resources do
      dept_name { 'Human Resources' }
    end

    trait :it do
      dept_name { 'IT' }
    end

    trait :legal do
      dept_name { 'Legal' }
    end

    trait :marketing do
      dept_name { 'Marketing' }
    end

    trait :operations do
      dept_name { 'Operations' }
    end

    trait :product_management do
      dept_name { 'Product Management' }
    end

    trait :public_relations do
      dept_name { 'Public Relations' }
    end

    trait :quality do
      dept_name { 'Quality' }
    end

    trait :sales do
      dept_name { 'Sales' }
    end

    trait :science do
      dept_name { 'Science' }
    end

    trait :supply_chain do
      dept_name { 'Supply Chain' }
    end
  end
end
