class College
  include Mongoid::Document

  # Create a college:
  # College.create(name: 'Stanford University', users_meta_data: {'534d861685db9e8cfd000001' => {start_date: "9/1/2001", end_date: "5/15/2005", degree_type: 'Bachelor of Science (BS)', major: 'Mathematics'}})
  # College.create(name: 'Columbia University', users_meta_data: {'534d861685db9e8cfd000001' => {start_date: "9/1/2005", end_date: "5/15/2009", degree_type: 'Master of Science (MS)', major: 'Mathematics'}})
  # College.create(name: 'Stanford University', users_meta_data: {})
  # College.create(name: 'Columbia University', users_meta_data: {})
  # College.create(name: 'Massachusetts Institute of Technology', users_meta_data: {})
  # College.create(name: 'Yale University', users_meta_data: {})
  
  # user_metadata
  # { user_id:
  #   { start_date: 1/1/2017, end_date: 1/1/2020, degree_type: 'Masters', major: 'Mathematics' }
  # }
  field :name, type: String
  field :users_meta_data, type: Hash, default: {}
  field :start_date, type: String
  field :end_date, type: String
  field :degree_type, type: String
  field :major, type: String
 	
  has_and_belongs_to_many :users
end
