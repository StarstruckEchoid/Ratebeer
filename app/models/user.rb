class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3,
                                 maximum: 30 }

  validates :password, length: { minimum: 4 },
                       format: { with: /(?=.*\d+)(?=.*[A-Z]+)/, message: "Password must contain a number and an uppercase letter." }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def favorite_style
    return nil if ratings.empty?

    ratings_by_style = ratings.group_by{ |r| r.beer.style }
    ratings_by_style.keys.max_by{ |k| array_average(ratings_by_style[k].map(&:score)) }
  end

  private

  def array_average(array)
    size = array.count
    return nil if size.zero?

    sum = array.reduce(0.0){ |total, x| total + x }
    sum / size
  end
end
