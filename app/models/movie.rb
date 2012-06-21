class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  class NoSimilarMovies < StandardError
  end
  
  def similar_movies 
    if director.blank?
      raise NoSimilarMovies.new("no director info")
    end
    Movie.find_all_by_director(director, :conditions => [ "id != ?", id])
  end
end

