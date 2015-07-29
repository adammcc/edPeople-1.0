namespace :email do
  desc "Resets an original user's password and sends them in invitation to our new site"
  task :original_users => :environment do

    # users = User.where(original_user: true)
    users = User.where(email: 'ajm845@gmail.com')

    users.each do |user|
      random_password = User.send(:generate_token, 'encrypted_password').slice(0, 8)
      user.password = random_password
      user.added_password = false
      user.dont_show_add_password_page = false
      user.save

      EpMailer.original_user_password_reset(user, random_password).deliver

    end
  end
end