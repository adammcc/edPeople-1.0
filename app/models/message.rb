class Message
  include Mongoid::Document
  include Mongoid::Timestamps

  field :note, type: String
  field :viewed_by_ids, type: Array, default: []

  belongs_to :conversation
  belongs_to :user

  validates :note, presence: true

end