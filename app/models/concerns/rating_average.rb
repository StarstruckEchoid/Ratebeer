module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    rs = ratings
    rc = rs.count
    return default if rc.zero?

    sum = rs.reduce(0.0){ |total, r| total + r.score }
    sum / rc
  end

end
