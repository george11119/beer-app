class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: -> {
                                                            Time.now.year
                                                          }.call,
                                   only_integer: true }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name.to_s
  end
end
