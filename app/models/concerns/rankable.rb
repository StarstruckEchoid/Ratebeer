module Rankable
  extend ActiveSupport::Concern

  def best(how_many = 3)
    all.sort_by{ |b| -(b.average_rating || 0) }.first how_many
  end
end
