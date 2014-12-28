class JobPost
  include Mongoid::Document
  include Mongoid::Timestamps

  field :title,         type: String
  field :organization,  type: String
  field :location,      type: String
  field :neighborhood,  type: String
  field :contact_info,  type: String
  field :org_website,   type: String
  field :description,   type: String

  has_and_belongs_to_many :users
end
