module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    rs = ratings
    rc = rs.count
    return nil if rc.zero?

    sum = rs.reduce(0.0){ |total, r| total + r.score }
    sum / rc
  end

  def rating_count
    ratings.count
  end

  def self.compare
    ->(a, b) { b.safe_average_rating <=> a.safe_average_rating }
  end

  def safe_average_rating
    average_rating || -1
  end
end
