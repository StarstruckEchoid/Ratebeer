class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    def average_rating
        sum = 0.0
        rs = self.ratings.all
        rc = rs.count
        return nil if (rc==0)
        rs.each do |r|
            sum+=r.score
        end
        sum/rc
    end
end
