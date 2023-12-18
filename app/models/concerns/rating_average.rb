module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings = self.ratings
    num_ratings = ratings.count

    if num_ratings == 0
      return "no ratings yet"
    end

    average_rating = ratings.average(:score)
    "#{self.name} has #{num_ratings} #{"rating".pluralize(num_ratings)} with an average of #{average_rating}"
  end
end