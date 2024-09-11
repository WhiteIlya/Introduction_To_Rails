class User < ApplicationRecord
    has_secure_password
    validates :email, uniqueness: true
    has_many :friends, dependent: :destroy  # Each user can have many friends - On to many and on destroy
end
