# frozen_string_literal: true

class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { less_than_or_equal_to: :current_year,
                                   greater_than_or_equal_to: 1040,
                                   only_integer: true }

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }
  scope :best, -> { all.sort( & RatingAverage.compare ).first 3 }

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2018
    puts "changed year to #{year}"
  end

  def to_s
    name
  end

  private

  def current_year
    Time.new.year
  end
end
