class Conversation
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search

  field :removed_for_ids, type: Array, default: []

  has_and_belongs_to_many :users
  has_many :messages

  search_in users: [ :first_name, :last_name ], messages: [ :note ]

end
