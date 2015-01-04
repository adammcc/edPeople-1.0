class JobPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  field :title,         type: String
  field :organization,  type: String
  field :neighborhood,  type: String
  field :contact_info,  type: String
  field :org_website,   type: String
  field :description,   type: String

  # Ideed job fields
  field :indeed_key
  field :indeed_location
  field :indeed_url
  field :indeed_date

  belongs_to :user
  belongs_to :subject
  belongs_to :role
  belongs_to :location

  search_in :title, :organization, :location, :neighborhood, :contact_info, :org_website, :description
end
