class Skill
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  # attr_accessible :name

  has_and_belongs_to_many :users

end
