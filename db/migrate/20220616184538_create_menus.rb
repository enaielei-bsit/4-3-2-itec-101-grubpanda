class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.belongs_to(:kiosk, foreign_key: true)
      t.string :name
      t.integer :price
      t.string :description

      t.index([:kiosk_id, :name], unique: true)

      t.timestamps
    end
  end
end
