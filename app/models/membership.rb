class Membership < ApplicationRecord
  validates :user_id, presence: true,
                      uniqueness: { scope: :beer_club_id }

  belongs_to :user, dependent: :destroy
  belongs_to :beer_club, dependent: :destroy
end
