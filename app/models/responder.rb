class Responder < ApplicationRecord
  has_many :requests, inverse_of: :responder
  geocoded_by :full_street_address   # can also be an IP address
  after_validation :geocode          # auto-fetch coordinates

  def full_street_address
    return address + city + state
  end
end
