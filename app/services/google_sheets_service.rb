# app/services/google_sheets_service.rb

require 'google/apis/sheets_v4'
require 'googleauth'

class GoogleSheetsService
  def self.fetch_data(credentials_path, sheet_id, range_name)
    service = Google::Apis::SheetsV4::SheetsService.new
    service.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
      json_key_io: File.open(credentials_path),
      scope: Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY
    )
    response = service.get_spreadsheet_values(sheet_id, range_name)
    response.values || []
  rescue StandardError => e
    puts "Error fetching Google Sheets data: #{e.message}"
    []
  end
end
