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

job_salary_currencies.each do |currency|
  # Find by currency code
  currency_record = JobSalaryCurrency.find_by(currency_code: currency[:currency_code])

  unless currency_record
    begin
      # Create the new currency and log it for adjudication
      new_currency = JobSalaryCurrency.create!(
        currency_code: currency[:currency_code],
        error_details: "Currency not found in existing records",
        reference_id: nil, # Set reference_id if necessary
        resolved: false
      )

      # Log the adjudication entry
      Adjudication.create!(
        table_name: 'job_salary_currencies',
        error_details: "Currency #{currency[:currency_code]} not found and needs adjudication.",
        reference_id: new_currency.id,
        resolved: false
      )

      seeded_count += 1
      puts "Currency #{currency[:currency_code]} adjudicated."
    rescue StandardError => e
      puts "Error seeding job salary currency: #{currency[:currency_code]} - #{e.message}"
    end
  else
    existing_count += 1
    puts "Currency #{currency[:currency_code]} already exists."
  end
end

total_currencies = JobSalaryCurrency.count

puts "********* Seeded #{seeded_count} new job salary currencies. #{existing_count} currencies already existed. Total currencies in the table: #{total_currencies}."
