class User < ApplicationRecord
    has_secure_password
    validates :email, uniqueness: true
    has_many :friends, dependent: :destroy  # One to many and on destroy
end
