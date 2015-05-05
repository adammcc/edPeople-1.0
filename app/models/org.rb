class Org
  include Mongoid::Document
  include Mongoid::Timestamps
  include Geocoder::Model::Mongoid

  after_validation :geocode
  geocoded_by :address_or_name_for_geocode

  field :name,            type: String
  field :about,           type: String
  field :org_website,     type: String
  field :org_type,        type: String
  field :owner,           type: String

  field :borough,         type: String
  field :neighborhood,    type: String
  field :street_address,  type: String
  field :city,            type: String
  field :state,           type: String
  field :zip,             type: String
  field :coordinates,     :type => Array

  has_one :user
  has_many :job_posts

  def address
    "#{self.street_address} #{self.city} #{self.state} #{self.zip}"
  end

  private

  def address_or_name_for_geocode
    if self.street_address.present?
      return self.address
    else
      return self.name
    end
  end
end
