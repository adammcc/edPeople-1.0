class Experience
  include Mongoid::Document

  attr_accessible :title, :employer, :school, :start_date, :end_date, 
  :district, :boro, :description


  field :title, type: String
  field :employer, type: String
  field :school, type: String
  field :start_date, type: String
  field :end_date, type: String
  field :district, type: String
  field :boro, type: String
  field :description, type: String

  embedded_in :user
end
