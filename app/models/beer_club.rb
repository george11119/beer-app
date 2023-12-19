class BeerClub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  def to_s
    name.to_s
  end
end
