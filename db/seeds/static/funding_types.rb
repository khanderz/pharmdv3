# Seeding common funding types
funding_types = [
  { funding_type_name: 'ANGEL' },
  { funding_type_name: 'CONVERTIBLE_NOTE' },
  { funding_type_name: 'CORPORATE_ROUND' },
  { funding_type_name: 'DEBT_FINANCING' },
  { funding_type_name: 'EQUITY_CROWDFUNDING' },
  { funding_type_name: 'GRANT' },
  { funding_type_name: 'INITIAL_COIN_OFFERING' },
  { funding_type_name: 'NON_EQUITY_ASSISTANCE' },
  { funding_type_name: 'POST_IPO_DEBT' },
  { funding_type_name: 'POST_IPO_EQUITY' },
  { funding_type_name: 'POST_IPO_SECONDARY' },
  { funding_type_name: 'PRE_SEED' },
  { funding_type_name: 'PRIVATE_EQUITY' },
  { funding_type_name: 'PRODUCT_CROWDFUNDING' },
  { funding_type_name: 'SECONDARY_MARKET' },
  { funding_type_name: 'SEED' },
  { funding_type_name: 'SERIES_A' },
  { funding_type_name: 'SERIES_B' },
  { funding_type_name: 'SERIES_C' },
  { funding_type_name: 'SERIES_D' },
  { funding_type_name: 'SERIES_E' },
  { funding_type_name: 'SERIES_F' },
  { funding_type_name: 'SERIES_G' },
  { funding_type_name: 'SERIES_H' },
  { funding_type_name: 'SERIES_I' },
  { funding_type_name: 'SERIES_J' },
  { funding_type_name: 'SERIES_UNKNOWN_VENTURE' },
  { funding_type_name: 'UNDISCLOSED' },
  { funding_type_name: 'OTHER' }
]

funding_types.each do |funding_type|
  begin
    FundingType.find_or_create_by!(funding_type_name: funding_type[:funding_type_name])
  rescue StandardError => e
    puts "Error seeding funding type: #{funding_type[:funding_type_name]} - #{e.message}"
  end
end

puts "**********Seeded common funding types"
