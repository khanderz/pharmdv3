# frozen_string_literal: true

job_salary_currencies = [
  { currency_code: 'AUD', currency_sign: 'A$' }, # Australian Dollar
  { currency_code: 'BRL', currency_sign: 'R$' }, # Brazilian Real
  { currency_code: 'CAD', currency_sign: 'C$' }, # Canadian Dollar
  { currency_code: 'CHF', currency_sign: 'CHF' }, # Swiss Franc
  { currency_code: 'CNY', currency_sign: 'CN¥' }, # Chinese Yuan
  { currency_code: 'EUR', currency_sign: '€' }, # Euro
  { currency_code: 'GBP', currency_sign: '£' }, # British Pound Sterling
  { currency_code: 'INR', currency_sign: '₹' }, # Indian Rupee
  { currency_code: 'JPY', currency_sign: 'JP¥' }, # Japanese Yen
  { currency_code: 'KRW', currency_sign: '₩' }, # South Korean Won
  { currency_code: 'NZD', currency_sign: 'NZ$' }, # New Zealand Dollar
  { currency_code: 'SEK', currency_sign: 'kr' }, # Swedish Krona
  { currency_code: 'SGD', currency_sign: 'S$' }, # Singapore Dollar
  { currency_code: 'USD', currency_sign: '$' }, # US Dollar
  { currency_code: 'ZAR', currency_sign: 'R' }  # South African Rand
]

seeded_count = 0
existing_count = 0
updated_count = 0

job_salary_currencies.each do |currency|
  currency_record = JobSalaryCurrency.find_or_initialize_by(currency_code: currency[:currency_code])

  if currency_record.persisted?
    existing_count += 1
    updates_made = false

    if currency_record.currency_sign != currency[:currency_sign]
      currency_record.currency_sign = currency[:currency_sign]
      updates_made = true
    end

    if updates_made
      currency_record.save!
      updated_count += 1
      puts "Updated currency #{currency[:currency_code]} in the database."
    else
      puts "Currency #{currency[:currency_code]} is already up-to-date."
    end
  else
    currency_record.currency_sign = currency[:currency_sign]
    currency_record.save!
    seeded_count += 1
    puts "Seeded new job salary currency: #{currency[:currency_code]}"
  end
rescue StandardError => e
  puts "Error seeding job salary currency: #{currency[:currency_code]} - #{e.message}"
end

total_currencies_after = JobSalaryCurrency.count
puts "********* Seeded #{seeded_count} new job salary currencies. #{existing_count} currencies already existed. #{updated_count} currencies updated. Total currencies in the table: #{total_currencies_after}."
