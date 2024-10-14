# Seeding common job salary currencies
job_salary_currencies = [
  { currency_code: 'USD' }, # US Dollar
  { currency_code: 'EUR' }, # Euro
  { currency_code: 'GBP' }, # British Pound Sterling
  { currency_code: 'JPY' }, # Japanese Yen
  { currency_code: 'AUD' }, # Australian Dollar
  { currency_code: 'CAD' }, # Canadian Dollar
  { currency_code: 'CHF' }, # Swiss Franc
  { currency_code: 'CNY' }, # Chinese Yuan
  { currency_code: 'INR' }, # Indian Rupee
  { currency_code: 'NZD' }, # New Zealand Dollar
  { currency_code: 'BRL' }, # Brazilian Real
  { currency_code: 'ZAR' }, # South African Rand
  { currency_code: 'SEK' }, # Swedish Krona
  { currency_code: 'SGD' }, # Singapore Dollar
  { currency_code: 'KRW' }, # South Korean Won
]

job_salary_currencies.each do |currency|
  begin
    JobSalaryCurrency.find_or_create_by!(currency_code: currency[:currency_code])
  rescue StandardError => e
    puts "Error seeding job salary currency: #{currency[:currency_code]} - #{e.message}"
  end
end

puts "*********Seeded common job salary currencies"
