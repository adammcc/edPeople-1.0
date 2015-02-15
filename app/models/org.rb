class Org
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,            type: String
  field :about,           type: String
  field :org_website,     type: String
  field :street_address,  type: String
  field :street_address,  type: String
  field :borough,         type: String
  field :org_type,        type: String

  has_one :user
  has_many :job_posts
end
