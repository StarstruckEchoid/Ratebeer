class Rating < ApplicationRecord
    belongs_to :beer

    def new
        @rating = Rating.new
    end

    def to_s
        "#{self.beer.name}: #{self.score}"
    end
end
