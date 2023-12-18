class Rating < ApplicationRecord
  belongs_to :beer

  def to_s
    "name: #{self.beer.name}, rating: #{self.score}"
  end
end
