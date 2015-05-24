class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date

  def self.ratings
  	@all_ratings = ['G', 'PG', 'PG-13', 'R'] # this is a diferente variable from the controller one
  end
end
