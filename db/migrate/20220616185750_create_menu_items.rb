class CreateMenuItems < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_items do |t|
      t.belongs_to(:menu, foreign_key: true)
      t.belongs_to(:product, foreign_key: true)
      t.integer(:quantity)

      t.index([:menu_id, :product_id], unique: true)

      t.timestamps
    end
  end
end
