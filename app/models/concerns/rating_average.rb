module RatingAverage
    extend ActiveSupport::Concern
    
    def average_rating
        rs = self.ratings
        rc = rs.count
        return default if rc==0
        sum = rs.reduce(0.0){|total,r| total+=r.score }
        sum/rc
    end
end