class Responder < ApplicationRecord
  has_many :requests, inverse_of: :responder
end
