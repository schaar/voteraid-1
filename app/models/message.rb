class Message < ApplicationRecord
  belongs_to :request, inverse_of: :messages
end
