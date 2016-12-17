class User < ApplicationRecord

  validates :username, :password_digest, presence: true, uniqueness: true
  has_many  :sent_messages, foreign_key: :sender_id, class_name: "Message"
  has_many  :received_messages, foreign_key: :receiver_id, class_name: "Message"
  has_secure_password
end
