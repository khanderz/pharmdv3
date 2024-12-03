# frozen_string_literal: true

funding_types = [
  { funding_type_code: 'ANGEL', funding_type_name: 'Angel' },
  { funding_type_code: 'CONVERTIBLE_NOTE', funding_type_name: 'Convertible Note' },
  { funding_type_code: 'CORPORATE_ROUND', funding_type_name: 'Corporate Round' },
  { funding_type_code: 'DEBT_FINANCING', funding_type_name: 'Debt Financing' },
  { funding_type_code: 'EQUITY_CROWDFUNDING', funding_type_name: 'Equity Crowdfunding' },
  { funding_type_code: 'GRANT', funding_type_name: 'Grant' },
  { funding_type_code: 'INITIAL_COIN_OFFERING', funding_type_name: 'Initial Coin Offering' },
  { funding_type_code: 'NON_EQUITY_ASSISTANCE', funding_type_name: 'Non-Equity Assistance' },
  { funding_type_code: 'POST_IPO_DEBT', funding_type_name: 'Post-IPO Debt' },
  { funding_type_code: 'POST_IPO_EQUITY', funding_type_name: 'Post-IPO Equity' },
  { funding_type_code: 'POST_IPO_SECONDARY', funding_type_name: 'Post-IPO Secondary' },
  { funding_type_code: 'PRE_SEED', funding_type_name: 'Pre-Seed' },
  { funding_type_code: 'PRIVATE_EQUITY', funding_type_name: 'Private Equity' },
  { funding_type_code: 'PRODUCT_CROWDFUNDING', funding_type_name: 'Product Crowdfunding' },
  { funding_type_code: 'SECONDARY_MARKET', funding_type_name: 'Secondary Market' },
  { funding_type_code: 'SEED', funding_type_name: 'Seed' },
  { funding_type_code: 'SERIES_A', funding_type_name: 'Series A' },
  { funding_type_code: 'SERIES_B', funding_type_name: 'Series B' },
  { funding_type_code: 'SERIES_C', funding_type_name: 'Series C' },
  { funding_type_code: 'SERIES_D', funding_type_name: 'Series D' },
  { funding_type_code: 'SERIES_E', funding_type_name: 'Series E' },
  { funding_type_code: 'SERIES_F', funding_type_name: 'Series F' },
  { funding_type_code: 'SERIES_G', funding_type_name: 'Series G' },
  { funding_type_code: 'SERIES_H', funding_type_name: 'Series H' },
  { funding_type_code: 'SERIES_I', funding_type_name: 'Series I' },
  { funding_type_code: 'SERIES_J', funding_type_name: 'Series J' },
  { funding_type_code: 'SERIES_UNKNOWN', funding_type_name: 'Series Unknown' },
  { funding_type_code: 'SERIES_UNKNOWN_VENTURE', funding_type_name: 'Series Unknown Venture' },
  { funding_type_code: 'UNDISCLOSED', funding_type_name: 'Undisclosed' },
  { funding_type_code: 'OTHER', funding_type_name: 'Other' }
]

seeded_count = 0
existing_count = 0
updated_count = 0

funding_types.each do |funding_type|
  funding_type_record = FundingType.find_or_initialize_by(funding_type_code: funding_type[:funding_type_code])

  if funding_type_record.persisted?
    existing_count += 1
    updates_made = false

    if funding_type_record.funding_type_name != funding_type[:funding_type_name]
      funding_type_record.funding_type_name = funding_type[:funding_type_name]
      updates_made = true
    end

    if updates_made
      funding_type_record.save!
      updated_count += 1
      puts "Updated funding type #{funding_type[:funding_type_code]} in the database."
    else
      puts "Funding type #{funding_type[:funding_type_code]} is already up-to-date."
    end
  else
    funding_type_record.funding_type_name = funding_type[:funding_type_name]
    funding_type_record.save!
    seeded_count += 1
    puts "Seeded new funding type: #{funding_type[:funding_type_code]}"
  end
rescue StandardError => e
  puts "Error seeding funding type: #{funding_type[:funding_type_code]} - #{e.message}"
end

total_funding_types_after = FundingType.count
puts "********* Seeded #{seeded_count} new funding types. #{existing_count} funding types already existed. #{updated_count} funding types updated. Total funding types in the table: #{total_funding_types_after}."
