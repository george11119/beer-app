class RemoveStyleFromBeers < ActiveRecord::Migration[7.0]
  def change
    remove_column :beers, :style
  end
end
