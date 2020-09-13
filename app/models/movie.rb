class Movie < ActiveRecord::Base
    def self.movie_ratings
        ratings = Array.new
        self.select("rating").distinct.each {|x| ratings << x.rating}
        ratings
    end
end