class AddAddressToKiosks < ActiveRecord::Migration[7.0]
  def change
    add_belongs_to(:kiosks, :address, foreign_key: true)
  end
end
