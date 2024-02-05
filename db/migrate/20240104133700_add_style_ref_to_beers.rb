class AddStyleRefToBeers < ActiveRecord::Migration[7.0]
  def change
    add_reference :beers, :style, foreign_key: true
  end
end
