module Ep
  class Importer
    def initialize
      google = GoogleDrive.login(ENV['EP_GOOGLE_USERNAME_2'], ENV['EP_GOOGLE_PASSWORD_2'])
      @spreadsheet = google.spreadsheet_by_url(ENV['XPAND_GOOGLE_SPREADSHEET_URL_OG_USERS'])
    end

    def pull_users
      for row in @spreadsheet.worksheet_by_title('individuals').rows(1)
        user = User.create(
          first_name: row[0].strip,
          last_name: row[1].strip,
          email: Faker::Internet.email,
          original_user: true,
          confirmed_at: Time.now,
          password: 'password'
        )

        puts "Imported #{row[0].strip} #{row[1].strip}"
      end
    end

    def pull_orgs
      for row in @spreadsheet.worksheet_by_title('orgs').rows(1)
        org_user = User.create(
          as_org: true,
          first_name: row[2].strip,
          last_name: row[2].strip,
          email: Faker::Internet.email,
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
