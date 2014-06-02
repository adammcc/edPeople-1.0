LinkedIn.configure do |config| 
	config.token = ENV["EP_LINKEDIN_API_KEY"] 
	config.secret = ENV["EP_LINKEDIN_SECRET_KEY"] 
end