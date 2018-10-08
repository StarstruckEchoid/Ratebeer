class Style < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  scope :best, ->{ all.sort(& RatingAverage.compare).first 3 }

  def to_s
    name
  end
end
