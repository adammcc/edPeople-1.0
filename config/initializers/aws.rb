AWS.config(logger: Rails.logger)
AWS.config({
  :access_key_id => ENV['EP_AWS_API_KEY'],
  :secret_access_key => ENV['EP_AWS_API_SECRET'],
})