class Beer < ApplicationRecord
  include RatingAverage
  extend Rankable

  validates :name, presence: true
  validates :style, presence: true

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  def to_s
    "#{name} by #{brewery.name}"
  end
end
