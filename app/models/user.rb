class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /(?=.*\d+)(?=.*[A-Z]+)/, message: "Password must contain a number and an uppercase letter."}

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :memberships
  has_many :beer_clubs, through: :memberships
end
