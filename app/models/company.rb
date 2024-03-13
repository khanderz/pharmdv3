class Company < ApplicationRecord
  include AtsEnum
  include LastFundingTypesEnum
end

# how to set an active record's attribute in a ruby on rails application to only have a value from an object's keys 
# and how do i abstract the object into a different file to enhance code cleanliness