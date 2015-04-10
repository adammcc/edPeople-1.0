class JobPost
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Geocoder::Model::Mongoid

  geocoded_by :address_or_name_for_geocode

  field :title,         type: String
  field :organization,  type: String
  field :neighborhood,  type: String
  field :contact_info,  type: String
  field :org_website,   type: String
  field :description,   type: String

  field :street_address,  type: String
  field :city,            type: String
  field :state,           type: String
  field :zip,             type: String
  field :coordinates,     type: Array

  # Ideed job fields
  field :indeed_key
  field :indeed_location
  field :indeed_url
  field :indeed_date

  belongs_to :user
  belongs_to :subject
  belongs_to :role
  belongs_to :location

  search_in :title, :organization, :location, :neighborhood, :contact_info, :org_website, :description

  def address
    "#{self.street_address} #{self.city} #{self.state} #{self.zip}"
  end

  private

  def address_or_name_for_geocode
    if self.indeed_key.present?
      return "#{self.organization} New York City"
    else
      if self.street_address.present?
        return self.address
      else
        if self.user && self.user.as_org
          if self.user.org.street_address.present?
            return self.user.org.address
          else
            return self.user.org.name
          end
        end
      end
    end
  end

end
