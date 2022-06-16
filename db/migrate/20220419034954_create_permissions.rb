class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table(:permissions) do |t|
      t.belongs_to(:user, foreign_key: true)
      t.integer(:value)

      t.index([:user_id, :value], unique: true)

      t.timestamps
    end
  end
end
