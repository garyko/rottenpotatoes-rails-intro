class Movie < ActiveRecord::Base
  def self.ratings_include(selected_ratings)
    self.where(:rating => selected_ratings)
  end
end
