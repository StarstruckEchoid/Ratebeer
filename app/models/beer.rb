class Beer < ApplicationRecord
    belongs_to :brewery
    has_many :ratings

    def average_rating
        rs = self.ratings
        sum = rs.inject(0.0){|s,r| s += r.score } 
        rc = rs.count
        return nil if (rc==0)
        sum/rc
    end
end
