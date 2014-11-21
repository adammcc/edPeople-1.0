class User
  include Mongoid::Document
  # include Amistad::FriendModel
  include Mongoid::Paperclip

  # validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  # validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :first_name, :last_name, :email, :password, :password_confirmation,
  # :remember_me, :pro_summary, :skill, :headline, :image_url, :experiences, :demo, :avatar

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
  field :headline,    type: String, default: 'Headline'
  field :demo,        type: Boolean, default: false

  field :provider,    type: String
  field :uid,         type: String

  has_and_belongs_to_many :colleges
  has_and_belongs_to_many :skills
  has_mongoid_attached_file :avatar, :styles => { :medium => "120x120#", :thumb => "50x50#" }, :default_url => "/images/:style/missing.png"
  has_and_belongs_to_many :experiences

  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
  validates_attachment_size :avatar, :less_than => 5.megabytes


  def name
    "#{first_name} #{last_name}"
  end

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      user.sync_with_linkedin(user, auth)
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.sync_with_linkedin(registered_user, auth)
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
        @user.sync_with_linkedin(@user, auth)
      end
    end
    return @user
  end

  def sync_with_linkedin(user, auth)
    client = LinkedIn::Client.new
    client.authorize_from_access(auth.extra.access_token.token, auth.extra.access_token.secret)

    user.image_url = client.picture_urls.all.first

    profile = client.profile(:fields => %w(positions educations skills headline))
    profile.to_hash

    user.headline = profile.headline
    user.save

    user_experiences = user.experiences.map { |exp| exp.linkedin_id }
    positions = profile.positions.to_hash
    positions["all"].each do |p|
      if !user_experiences.include? p["id"].to_s
        exp = Experience.create(title: p["title"],
                                employer: p["company"]["name"],
                                start_date: "#{p["start_date"]["month"]}/#{p["start_date"]["year"]}",
                                is_current: p["is_current"],
                                description: p["summary"],
                                linkedin_id: p["id"])
        exp.save
        user.experiences << exp
        if p["end_date"]
          exp.end_date = "#{p["end_date"]["month"]}/#{p["end_date"]["year"]}"
          exp.save
        end
      end
    end

    skills = profile.skills.to_hash
    skills["all"].each do |s|
      if !user.skills.any? { |skill| skill.name == s["skill"]["name"] }
        skill = Skill.create(name: s["skill"]["name"])
        user.skills << skill
        user.save
      end
    end

    educations = profile.educations.to_hash
    educations["all"].each do |e|
      if !College.all.any? { |education| education.name == e["school_name"]}
        college = College.create(name: e["school_name"])
        college.users_meta_data[user.id.to_s] = { start_date: e["start_date"]["year"],
                                             end_date: e["end_date"]["year"],
                                             degree_type: e["degree"],
                                             major: e["field_of_study"] }
        college.save
        user.colleges << college
      else
        college = College.where(name: e["school_name"])
        college.first.users_meta_data[user.id.to_s] = { start_date: e["start_date"]["year"],
                                                   end_date: e["end_date"]["year"],
                                                   degree_type: e["degree"],
                                                   major: e["field_of_study"] }
        college.first.save
        user.colleges << college.first
      end
    end
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

# Full Profile
# {"educations"=>{"total"=>3,
#                 "all"=>[{"degree"=>"M.A.",
#                         "end_date"=>{"year"=>2011},
#                         "field_of_study"=>"Teaching English to Speakers of Other Languages",
#                         "id"=>59228633,
#                         "school_name"=>"City University of New York-Hunter College",
#                         "start_date"=>{"year"=>2010}},
#                       {"degree"=>"M.A.",
#                         "end_date"=>{"year"=>2006},
#                         "field_of_study"=>"French Cultural Studies",
#                         "id"=>7830316,
#                         "school_name"=>"Columbia University in the City of New York",
#                         "start_date"=>{"year"=>2005}},
#                       {"activities"=>"",
#                           "degree"=>"B.A.",
#                           "end_date"=>{"year"=>2002},
#                           "field_of_study"=>"TV, Radio and Film; French (dual major)",
#                           "id"=>5986863,
#                           "notes"=>"",
#                           "school_name"=>"Syracuse University",
#                           "start_date"=>{"year"=>1998}}]},
# "positions"=>{"total"=>6,
#               "all"=>[{"company"=>{"id"=>1419465,
#                       "industry"=>"Education Management",
#                       "name"=>"PS 58 The Carroll School"},
#                       "id"=>313027805,
#                       "is_current"=>true,
#                       "start_date"=>{"month"=>9, "year"=>2012},
#                       "title"=>"Fifth Grade Dual Language Teacher"},
#                     {"company"=>{"industry"=>"Education Management",
#                       "name"=>"edPeople"},
#                       "id"=>404714900,
#                       "is_current"=>true,
#                       "start_date"=>{"month"=>3, "year"=>2012},
#                       "summary"=>"Co-founded a professional networking site for NYC's educators. We launched in beta in June 2013: www.edpeople.com",
#                       "title"=>"Co-Founder"},
#                     {"company"=>{"id"=>2624,
#                       "industry"=>"Higher Education",
#                       "name"=>"Columbia University",
#                       "size"=>"10,001+ employees",
#                       "type"=>"Educational Institution"},
#                       "end_date"=>{"month"=>6, "year"=>2012},
#                       "id"=>258745315,
#                       "is_current"=>false,
#                       "start_date"=>{"month"=>4, "year"=>2011},
#                       "title"=>"Development Officer"},
#                     {"company"=>{"id"=>2624,
#                       "industry"=>"Higher Education",
#                       "name"=>"Columbia University",
#                       "size"=>"10,001+ employees",
#                       "type"=>"Educational Institution"},
#                       "end_date"=>{"month"=>5, "year"=>2011},
#                       "id"=>55459737,
#                       "is_current"=>false,
#                       "start_date"=>{"month"=>10, "year"=>2008},
#                       "title"=>"Associate Director of Development"},
#                     {"company"=>{"id"=>2624,
#                       "industry"=>"Higher Education",
#                       "name"=>"Columbia University",
#                       "type"=>"Educational Institution"},
#                       "end_date"=>{"month"=>10, "year"=>2008},
#                       "id"=>13348122,
#                       "is_current"=>false,
#                       "start_date"=>{"month"=>1, "year"=>2007},
#                       "summary"=>"",
#                       "title"=>"Assistant Director of Development"},
#                     {"company"=>{"id"=>13174,
#                       "industry"=>"Investment Management",
#                       "name"=>"Soros Fund Management",
#                       "size"=>"201-500 employees",
#                       "type"=>"Privately Held"},
#                       "end_date"=>{"month"=>12, "year"=>2006},
#                       "id"=>275866123,
#                       "is_current"=>false,
#                       "start_date"=>{"month"=>2, "year"=>2005},
#                       "title"=>"Assistant"}]},
# "skills"=>{"total"=>10,
#            "all"=>[{"id"=>10, "skill"=>{"name"=>"Volunteer Management"}},
#                   {"id"=>11, "skill"=>{"name"=>"Fundraising"}},
#                   {"id"=>12, "skill"=>{"name"=>"Higher Education"}},
#                   {"id"=>13, "skill"=>{"name"=>"Non-profits"}},
#                   {"id"=>14, "skill"=>{"name"=>"Alumni Relations"}},
#                   {"id"=>15, "skill"=>{"name"=>"Public Education"}},
#                   {"id"=>16, "skill"=>{"name"=>"Language Teaching"}},
#                   {"id"=>20, "skill"=>{"name"=>"French"}},
#                   {"id"=>23, "skill"=>{"name"=>"Educational Technology"}},
#                   {"id"=>24, "skill"=>{"name"=>"Lean Startup"}}]}}










