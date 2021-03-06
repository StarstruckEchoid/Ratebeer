class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  def confirmed_memberships
    memberships.where confirmed: true
  end

  def pending_requests
    memberships.where confirmed: false
  end

  def confirmed_member?(user)
    memberships.where(confirmed: true, user: user).present?
  end

  def to_s
    name
  end
end
