class Movie < ActiveRecord::Base
  def self.filter(selected_ratings)
    selected_ratings.empty? ? self.all : self.where(:rating => selected_ratings)
  end

  def self.order_by(column)
    ["title", "release_date"].include?(column) ? self.order(column) : self.all
  end


end
