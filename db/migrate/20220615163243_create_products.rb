class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :serving_size
      t.string :description

      t.index(:name, unique: true)

      t.timestamps
    end
  end
end
