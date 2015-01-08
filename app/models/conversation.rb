class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search


  has_and_belongs_to_many :users
  has_many :messages

  search_in users: [ :first_name, :last_name ], messages: [ :note ]

end
