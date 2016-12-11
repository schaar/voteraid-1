class Request < ApplicationRecord
  belongs_to :responder, inverse_of: :requests, optional: true
  has_many :messages, inverse_of: :request

end
