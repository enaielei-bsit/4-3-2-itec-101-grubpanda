class AddNameIndexToKiosks < ActiveRecord::Migration[7.0]
  def change
    add_index(:kiosks, :name, unique: true)
  end
end
