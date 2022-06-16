class CreateKiosks < ActiveRecord::Migration[7.0]
  def change
    create_table :kiosks do |t|
      t.string(:name)
      t.string(:email)
      t.string(:mobile_number)

      t.string(:description)

      t.timestamps
    end
  end
end
