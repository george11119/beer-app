module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return "no ratings yet" if ratings.empty?

    average_rating = ratings.average(:score)
    "has #{ratings.count} #{'rating'.pluralize(ratings.count)} with an average of #{average_rating}"
  end
end
