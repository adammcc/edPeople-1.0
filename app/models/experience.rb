class Experience
  include Mongoid::Document
  include Mongoid::Timestamps

  # attr_accessible :title, :employer, :school, :start_date, :end_date,
  # :district, :boro, :description


  field :title, type: String, default: nil
  field :employer, type: String
  field :school, type: String
  field :start_date, type: String
  field :end_date, type: String
  field :district, type: String
  field :boro, type: String
  field :description, type: String
  field :start_date, type: String
  field :end_date, type: String
  field :is_current, type: Boolean
  field :linkedin_id, type: String

  has_and_belongs_to_many :users

  validates_presence_of :title, :start_date
end
