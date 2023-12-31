class PasswordValidator < ActiveModel::Validator
  def validate(user)
    return if user.password.nil?

    unless user.password.length >= 4
      user.errors.add :password, "must be longer than 4 characters"
    end

    unless user.password.match(/[A-Z]+/)
      user.errors.add :password, "must contain at least one capital letter"
    end
    return if user.password.match(/[0-9]/)

    user.errors.add :password, "must contain at least 1 number"
  end
end

class User < ApplicationRecord
  include RatingAverage

  has_secure_password
  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }
  validates_with PasswordValidator

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(:score).last.beer
  end

  def favorite_style
    return nil if ratings.empty?

    Beer.find_by_sql(
      "
      SELECT style, AVG(score) as average_score FROM beers
      INNER JOIN 'ratings' ON 'ratings'.'beer_id' = 'beers'.'id'
      WHERE 'ratings'.'user_id' = #{id}
      GROUP BY 'beers'.'style'
      ORDER BY average_score DESC LIMIT 1
    ",
    ).to_a[
      0
    ][
      :style
    ]
  end

  def favorite_brewery
    return nil if ratings.empty?

    Brewery.find_by_sql(
      "
      SELECT breweries.name, AVG(score) as average_score FROM beers
      INNER JOIN 'ratings' ON 'ratings'.'beer_id' = 'beers'.'id'
      INNER JOIN 'breweries' ON 'beers'.'brewery_id' = 'breweries'.'id'
      WHERE 'ratings'.'user_id' = #{id}
      GROUP BY 'breweries'.'name'
      ORDER BY average_score DESC LIMIT 1
    ",
    ).to_a[
      0
    ][
      :name
    ]
  end
end
