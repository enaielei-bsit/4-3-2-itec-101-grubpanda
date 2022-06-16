class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :region
      t.string :province
      t.string :city
      t.string :barangay
      t.string :street

      t.timestamps
    end
  end
end
