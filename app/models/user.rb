class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Amistad::FriendModel
  include Mongoid::Paperclip
  include Mongoid::Search

  scope :just_users, lambda { where(as_org: false) }
  scope :just_orgs, lambda { where(as_org: true) }

  # validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  # validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :confirmable

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
  field :confirmation_token,   :type => String
  field :confirmed_at,         :type => Time
  field :confirmation_sent_at, :type => Time
  field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time
  field :first_name,  type: String
  field :last_name,   type: String
  field :image_url,   type: String, default: "/images/original/missing.png"
  field :email,       type: String
  field :pro_summary, type: String
  field :skill,       type: String
  field :headline,    type: String
  field :demo,        type: Boolean, default: false
  field :has_resume,  type: Boolean, default: false
  field :original_user, type: Boolean, default: false
  field :sent_original_user_invite, type: Boolean, default: false

  # User choices
  field :privacy_setting, type: String, default: 'fully_public' # other options: 'only members' and 'only connections'
  field :allows_one_on_one_message_email, type: Boolean, default: true
  field :allows_friend_request_email, type: Boolean, default: true
  field :dont_show_add_password_page, type: Boolean, default: false

  field :as_org,      type: Boolean, default: false

  field :provider,    type: String
  field :uid,         type: String
  field :has_linkedin_account, type: Boolean, default: false
  field :added_password, type: Boolean, default: false

  has_and_belongs_to_many :colleges
  has_many :college_infos
  has_and_belongs_to_many :skills
  has_and_belongs_to_many :certs
  has_and_belongs_to_many :experiences
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :subjects
  has_many :job_posts, dependent: :destroy
  has_and_belongs_to_many :conversations
  has_many :messages
  belongs_to :org

  search_in :first_name, :last_name, :email, :headline, :role, :subject_area,
            skills: :name,
            colleges: [ :name, :degree_type, :major ],
            experiences: [ :title, :employer, :school, :boro ],
            roles: :name,
            subjects: :name,
            org: [:name, :about, :org_website, :street_address, :borough, :org_type]

  has_mongoid_attached_file :avatar,
    :storage        => :s3,
    :bucket_name    => 'my-uploads',
    :path           => ':attachment/:id/:style.:extension',
    :s3_credentials => { bucket: "ep-#{ENV['EP_AWS_S3BUCKET']}-avatar", :access_key_id => ENV['EP_AWS_API_KEY'], :secret_access_key => ENV['EP_AWS_API_SECRET'] },
    :styles => { :medium => "120x120#", :thumb => "50x50#" }

  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
  validates_attachment_size :avatar, :less_than => 5.megabytes

  accepts_nested_attributes_for :org

  validates_presence_of :first_name, :last_name, :email

  def self.users_with_info
    all_users = User.where(as_org: false)
    users_with_info = []
    all_users.shuffle.each do |user|
      if user.has_profile_info && user.has_profile_image?
        users_with_info << user
        break if users_with_info.count == 4
      end
    end
    return users_with_info
  end

  def name
    if as_org
      org.name
    else
      "#{first_name} #{last_name}"
    end
  end

  def update_name(full_name)
    split_full_name = full_name.split(' ', 2)
    self.first_name = split_full_name[0]
    self.last_name = split_full_name[1]
    self.save
  end

  def remove_all_friends
    friends.each do |friend|
      remove_friendship friend
    end

    pending_invited.each do |f|
      remove_friendship f
    end

    pending_invited_by.each do |f|
      remove_friendship f
    end
  end

  def self.connect_to_linkedin(auth, signed_in_resource=nil)
    if signed_in_resource.present? && signed_in_resource.email == auth.info.email
      signed_in_resource.sync_with_linkedin(signed_in_resource, auth)
      return signed_in_resource
    elsif signed_in_resource.nil?
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        registered_user.sync_with_linkedin(registered_user, auth)
        return registered_user
      else
        if new_user = User.new(
          first_name:auth.info.first_name,
          last_name:auth.info.last_name,
          headline:auth.info.headline,
          pro_summary:auth.info.summary,
          provider:auth.provider,
          uid:auth.uid,
          email:auth.info.email,
          password:Devise.friendly_token[0,20],
          has_linkedin_account:true,
          confirmed_at: DateTime.now
        )
          new_user.skip_confirmation!
          new_user.save!
          new_user.sync_with_linkedin(new_user, auth)
        end
      end
    end
    return new_user
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
    if positions["all"].present?
      positions["all"].each do |p|

        company = p["company"]
        company.present? ? company = company["name"] : company = nil

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
    end

    # skills = profile.skills.to_hash
    # if skills["all"].present?
    #   skills["all"].each do |s|
    #     if !user.skills.any? { |skill| skill.name == s["skill"]["name"] }
    #       skill = Skill.create(name: s["skill"]["name"])
    #       user.skills << skill
    #       user.save
    #     end
    #   end
    # end

    # user_educations = user.college_infos.map { |edu| edu.linkedin_id }
    # educations = profile.educations.to_hash
    # if educations["all"].present?
    #   educations["all"].each do |e|
    #     if !user_educations.include? e["id"].to_s
    #       if College.all.any? { |education| education.name == e["school_name"]}
    #         college = College.where(name: e["school_name"]).first
    #       else
    #         college = College.create(name: e["school_name"])
    #       end

    #       start_date = e["start_date"]
    #       start_date.present? ? start_date_year = start_date["year"] : start_date_year = nil

    #       end_date = e["end_date"]
    #       end_date.present? ? end_date_year = end_date["year"] : end_date_year = nil

    #       college.college_infos.create( start_date: start_date_year,
    #                                     end_date: end_date_year,
    #                                     degree_type: e["degree"],
    #                                     major: e["field_of_study"],
    #                                     user: user,
    #                                     linkedin_id: e["id"])
    #       user.colleges << college
    #     end
    #   end
    # end
  end

  def upload_resume_to_s3(user, resume)
    s3 = AWS::S3.new()
    bucket_path = Ep::Lib.bucket_path('resumes')
    object_path = resume.original_filename

    bucket = s3.buckets[bucket_path]
    if !bucket.exists?
      bucket = s3.buckets.create(bucket_path)
    end

    bucket.objects.create(user.id, resume.tempfile.read(), acl: :public_read)
  end

  def delete_resume_from_s3
    s3 = AWS::S3.new
    bucket = s3.buckets['ep-dev-resumes']
    name = self.id.to_s
    bucket.objects.delete(name)
    self.has_resume = false
    self.save
  end

  def delete_avatar_from_s3
    s3 = AWS::S3.new
    bucket = s3.buckets['ep-dev-avatar/avatars']
    name = self.id.to_s
    bucket.objects.delete(name)
  end

  def unread_messages_count(conversations)
    unread_messages_count = 0
    conversations.each do |convo|
      convo.messages.each do |message|
        unread_messages_count += 1 if !message.viewed_by_ids.include?(self.id)
      end
    end
    unread_messages_count
  end

  def photo_url(size = nil)
    if avatar.present?
      case size
      when nil
        avatar.url
      when 'medium'
        avatar.url(:medium)
      when 'thumb'
        avatar.url(:thumb)
      end
    else
      image_url
    end
  end

  def has_profile_image?
   !["/images/original/missing.png", ""].include? photo_url
  end

  def gives_access_to(user)
    self.privacy_setting == 'fully_public' ||
    (self.privacy_setting == 'only_members' && user.present?) ||
    (self.privacy_setting == 'only_connections' && user.present? && self.friend_with?(user))
  end

  def is_admin?
    self.roles.where(name: 'Administrator').any?
  end

  def has_profile_info
    experiences.present? ||
    college_infos.present? ||
    certs.present? ||
    skills.present? ||
    friends.present?
  end

  def profile_progress
    progress = 0
    progress += 10 if first_name.present? && last_name.present?
    progress += 10 if headline.present?
    progress += 10 if has_profile_image?
    progress += 10 if has_experiences?
    progress += 10 if has_college_infos?
    progress += 10 if has_certs?
    progress += 10 if has_skills?
    progress += 10 if has_roles?
    progress += 10 if has_subjects?
    progress += 10 if has_resume
    progress
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










