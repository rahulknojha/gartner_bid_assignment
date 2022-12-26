class AddIndexOnBidsColumns < ActiveRecord::Migration[7.0]
  def change
    add_index :bids, %i[country category channel]
  end
end
