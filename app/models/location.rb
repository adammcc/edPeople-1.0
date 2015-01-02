class Location
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_many :job_posts
end