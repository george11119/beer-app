class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { minimum: 3, maximum: 30 }
  validates_with PasswordValidator

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships
end

class PasswordValidator < ActiveModel::Validator
  def validate(user)
    return if user.password.nil?

    unless user.password.length >= 4
      user.errors.add :password,
                      "must be longer than 4 characters"
    end

    unless user.password.match(/[A-Z]+/)
      user.errors.add :password,
                      "must contain at least one capital letter"
    end
    return if user.password.match(/[^\w\s]/)

    user.errors.add :password,
                    "must contain at least 1 special character"
  end
end
