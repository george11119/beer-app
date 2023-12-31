module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return "no ratings yet" if ratings.empty?

    ratings.average(:score)
  end
end
