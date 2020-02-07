class Movie < ActiveRecord::Base
    # Case-insensitive filtered search for movies with ratings given
    def self.with_ratings(ratings)
        return where(:rating => ratings)
    end
end
