class CreateBids < ActiveRecord::Migration[6.0]
  def change
    create_table :bids do |t|
      t.string :country
      t.string :category
      t.string :channel
      t.decimal :amount

      t.timestamps
    end
  end
end
