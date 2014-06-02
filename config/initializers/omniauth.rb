# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :linkedin, ENV["EP_LINKEDIN_API_KEY"], ENV["EP_LINKEDIN_SECRET_KEY"], 
#            :scope => 'r_fullprofile r_emailaddress r_network', 
#            :fields => ["id", "email-address", "first-name", "last-name",
#            	"headline", "industry", "picture-url", "public-profile-url", "location",
#            	"summary", "connections", "skills", "three-current-positions"]
# end