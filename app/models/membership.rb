class Membership < ApplicationRecord
  validates :user_id, presence: true,
                      uniqueness: { scope: :beer_club_id }

  belongs_to :user
  belongs_to :beer_club
end
