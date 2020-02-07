class Movie < ActiveRecord::Base
  def self.with_ratings(ratings)
    self.where(rating: ratings)
  end

  def self.valid_ratings
    return ['G', 'PG', 'PG-13', 'R', 'NC-17']
  end
end
