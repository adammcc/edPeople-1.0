class College
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  has_and_belongs_to_many :users
  has_many :college_infos

  validates_presence_of :name
end
