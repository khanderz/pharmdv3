FactoryBot.define do
  factory :department do
    dept_name { "Default Department" }

    trait :executive do
      dept_name { "Executive" }
    end

    trait :clinical_team do
      dept_name { "Clinical Team" }
    end

    trait :sales do
      dept_name { "Sales" }
    end

    trait :marketing do
      dept_name { "Marketing" }
    end

    trait :operations do
      dept_name { "Operations" }
    end

    trait :data_science do
      dept_name { "Data Science" }
    end

    trait :it do
      dept_name { "IT" }
    end

    trait :quality do
      dept_name { "Quality" }
    end

    trait :science do
      dept_name { "Science" }
    end

    trait :human_resources do
      dept_name { "Human Resources" }
    end

    trait :customer_support do
      dept_name { "Customer Support" }
    end
  end
end
