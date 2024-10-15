# Seeding common job salary currencies
job_salary_currencies = [
  { currency_code: 'AUD' }, # Australian Dollar
  { currency_code: 'BRL' }, # Brazilian Real
  { currency_code: 'CAD' }, # Canadian Dollar
  { currency_code: 'CHF' }, # Swiss Franc
  { currency_code: 'CNY' }, # Chinese Yuan
  { currency_code: 'EUR' }, # Euro
  { currency_code: 'GBP' }, # British Pound Sterling
  { currency_code: 'INR' }, # Indian Rupee
  { currency_code: 'JPY' }, # Japanese Yen
  { currency_code: 'KRW' }, # South Korean Won
  { currency_code: 'NZD' }, # New Zealand Dollar
  { currency_code: 'SEK' }, # Swedish Krona
  { currency_code: 'SGD' }, # Singapore Dollar
  { currency_code: 'USD' }, # US Dollar
  { currency_code: 'ZAR' }, # South African Rand
]

seeded_count = 0
existing_count = 0
total_currencies = JobSalaryCurrency.count

job_salary_currencies.each do |currency|
  begin
    currency_record = JobSalaryCurrency.find_or_initialize_by(currency_code: currency[:currency_code])
    
    if currency_record.persisted?
      existing_count += 1
    else
      currency_record.save!
      seeded_count += 1
    end
  rescue StandardError => e
    puts "Error seeding job salary currency: #{currency[:currency_code]} - #{e.message}"
  end
end

total_currencies_after = JobSalaryCurrency.count

puts "*********Seeded #{seeded_count} new job salary currencies. #{existing_count} currencies already existed. Total currencies in the table: #{total_currencies_after}."
