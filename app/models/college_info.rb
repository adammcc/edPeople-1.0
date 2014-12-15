class CollegeInfo
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,        type: String
  field :start_date,  type: String
  field :end_date,    type: String
  field :degree_type, type: String
  field :major,       type: String
  field :linkedin_id, type: String

  belongs_to :user
  belongs_to :college
end

