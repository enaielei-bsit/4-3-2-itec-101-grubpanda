class CreatePurchases < ActiveRecord::Migration[7.0]
  def change
    create_table :purchases do |t|
      t.belongs_to(:user, foreign_key: true)
      t.belongs_to(:menu, foreign_key: true)
      t.belongs_to(:order, foreign_key: true, optional: true)
      t.integer(:price, default: -> {0})
      t.integer :quantity

      t.index([:user_id, :menu_id, :order_id], unique: true)

      t.timestamps
    end
  end
end
