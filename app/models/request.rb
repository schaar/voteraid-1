class Request < ApplicationRecord
  belongs_to :responder, inverse_of: :request
  has_many :messages, inverse_of: :request

end
