module Ep
  class Importer
    def initialize
      require "google/api_client"
      require "google_drive"
      require 'uri'

      # Authorizes with OAuth and gets an access token.
      client = Google::APIClient.new
      auth = client.authorization
      auth.client_id = ENV['GOOGLE_CLIENT_id']
      auth.client_secret = ENV['GOOGLE_CLIENT_SECRET']
      auth.scope = [
        "https://www.googleapis.com/auth/drive",
        "https://spreadsheets.google.com/feeds/"
      ]
      auth.redirect_uri = "http://edpeeps.herokuapp.com/oauth2callback"
      print("1. Open this page:\n%s\n\n" % auth.authorization_uri)
      print("2. Enter the authorization code shown in the page: ")
      auth.code = $stdin.gets.chomp
      auth.fetch_access_token!
      access_token = auth.access_token

      # Creates a session.
      google = GoogleDrive.login_with_oauth(access_token)
      @spreadsheet = google.spreadsheet_by_url(ENV['XPAND_GOOGLE_SPREADSHEET_URL_OG_USERS'])
    end

    def pull_users
      for row in @spreadsheet.worksheet_by_title('individuals').rows(1)
        user = User.create(
          first_name: row[0].strip,
          last_name: row[1].strip,
          email: row[2].strip,
          original_user: true,
          confirmed_at: Time.now,
          password: 'password'
        )

        puts "Imported #{row[0].strip} #{row[1].strip}"
      end
    end

    def pull_orgs
      for row in @spreadsheet.worksheet_by_title('orgs').rows(1)
        org_user = User.new(
          as_org: true,
          first_name: row[2].strip,
          last_name: row[2].strip,
          email: row[3].strip,
          original_user: true,
          confirmed_at: Time.now,
          password: 'password'
        )

        if org_user.save
          org_user.create_org(
            name: row[2].strip,
            owner: row[0].strip,
            borough: row[4].strip,
            neighborhood: row[5].strip,
            street_address: row[6].strip,
            city: row[7].strip,
            state: row[8].strip,
            zip: row[9].strip,
            about: row[10].strip,
            org_website: row[11].strip,
            org_type: row[12].strip,
          )
          org_user.save
        end


        puts "Imported #{row[0].strip} #{row[1].strip}"
      end
    end
  end
end


