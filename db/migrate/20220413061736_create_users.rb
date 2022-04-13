class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table(:users) do |t|
      t.string(:email)

      t.string(:family_name)
      t.string(:given_name)
      t.string(:middle_name)

      t.string(:region)
      t.string(:province)
      t.string(:city)
      t.string(:barangay)
      t.string(:street)

      t.boolean(:admin)

      t.string(:password_digest)
      t.string(:session_digest)

      t.index(:email, unique: true)

      t.timestamps
    end
  end
end
