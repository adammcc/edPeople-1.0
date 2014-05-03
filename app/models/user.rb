class User
  include Mongoid::Document
  include Amistad::FriendModel
  include Mongoid::Paperclip

  # validates_attachment_content_type :image, :content_type => ["image/jpg", "image/jpeg", "image/png"]
  # validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png"] }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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

  has_and_belongs_to_many :colleges
  has_and_belongs_to_many :skills
  has_mongoid_attached_file :avatar, :styles => { :medium => "120x120>", :thumb => "50x50>" }, :default_url => "/images/:style/missing.png"
  embeds_many :experiences

  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
  

  def name
    "#{first_name} #{last_name}"
  end
end
