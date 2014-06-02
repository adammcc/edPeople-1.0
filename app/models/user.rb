class User
  include Mongoid::Document
  include Amistad::FriendModel
  include Mongoid::Paperclip

  # validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  # validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
  :remember_me, :pro_summary, :skill, :headline, :image_url, :experiences, :demo, :avatar

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String
  

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
  field :first_name,  type: String
  field :last_name,   type: String
  field :image_url,   type: String
  field :email,       type: String
  field :pro_summary, type: String
  field :skill,       type: String
  field :headline,    type: String
  field :demo,        type: Boolean, default: false

  field :provider,    type: String 
  field :uid,         type: String

  has_and_belongs_to_many :colleges
  has_and_belongs_to_many :skills
  has_mongoid_attached_file :avatar, :styles => { :medium => "120x120#", :thumb => "50x50#" }, :default_url => "/images/:style/missing.png"
  embeds_many :experiences

  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
  validates_attachment_size :avatar, :less_than => 5.megabytes
  

  def name
    "#{first_name} #{last_name}"
  end

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p auth.info

    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      user.sync_to_linkedin(user, auth)
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.sync_to_linkedin(registered_user, auth)
        return registered_user
      else
        @user = User.create( first_name:auth.info.first_name,
                            last_name:auth.info.last_name,
                            headline:auth.info.headline,
                            pro_summary:auth.info.summary,
                            provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                          )
        @user.sync_to_linkedin(@user, auth)
      end
    end
    return @user
  end  

  def sync_to_linkedin(user, auth)
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    p "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    client = LinkedIn::Client.new
    client.authorize_from_access(auth.extra.access_token.token, auth.extra.access_token.secret)

    user.image_url = client.picture_urls.all.first
    
    @profile = client.profile(:fields => %w(positions educations skills))
    p @profile.to_hash

    positions = @profile.positions.to_hash
    positions["all"].each do |p|
      exists = false
      user.experiences.each do |ex|
        if ex.linkedin_id == p["id"]
          exists = true
        end
      end
      if exists == false
        user.experiences.create(title: p["title"],
                                employer: p["company"]["name"],
                                start_date: "#{p["start_date"]["month"]}/#{p["start_date"]["year"]}",
                                is_current: p["is_current"],
                                description: p["summary"],
                                linkedin_id: p["id"])
      end                   
    end

    # @profile = client.profile(:fields => %w(positions educations skills))
    # p @profile.to_hash
    # skills = client.profile(:fields => [:skills])
    # p skills

    # educations = client.profile(:fields => [:educations])
  end 
end
# positions:
# [{"company"=>{"id"=>1419465, "industry"=>"Education Management", 
#   "name"=>"PS 58 The Carroll School"}, 
#   "id"=>313027805, "is_current"=>true, 
#   "start_date"=>{"month"=>9, "year"=>2012}, 
#   "title"=>"Fifth Grade Dual Language Teacher"}, 

#   {"company"=>{"industry"=>"Education Management", "name"=>"edPeople"},
#    "id"=>404714900, 
#    "is_current"=>true, 
#    "start_date"=>{"month"=>3, "year"=>2012}, 
#    "summary"=>"Co-founded a professional networking site for NYC's educators. We launched in beta in June 2013: www.edpeople.com", 
#    "title"=>"Co-Founder"}]

# Profile
# {"first_name"=>"Natasha", 
#   "headline"=>"Fifth Grade Dual Language Teacher and Co-Founder of edPeople", 
#   "last_name"=>"Marra McCabe", 
#   "positions"=>{"total"=>2, 
#                 "all"=>[{"company"=>{"id"=>1419465, 
#                         "industry"=>"Education Management", 
#                         "name"=>"PS 58 The Carroll School"}, 
#                         "id"=>313027805, "is_current"=>true, "start_date"=>{"month"=>9, "year"=>2012}, 
#                         "title"=>"Fifth Grade Dual Language Teacher"}, 
#                         {"company"=>{"industry"=>"Education Management", 
#                           "name"=>"edPeople"}, 
#                           "id"=>404714900, 
#                           "is_current"=>true, 
#                           "start_date"=>{"month"=>3, "year"=>2012}, 
#                           "summary"=>"Co-founded a professional networking site for NYC's educators. We launched in beta in June 2013: www.edpeople.com", 
#                           "title"=>"Co-Founder"}]}}










