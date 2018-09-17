class BeerClub < ApplicationRecord
  has_many :members, through: :memberships, source: :users
end
