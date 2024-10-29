class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :credential
      t.json :resume
      t.string :photo
      t.datetime :last_login
      t.string :password_digest
      t.string :salt
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.string :provider
      t.string :uid
      t.string :access_token

      t.timestamps
    end
    add_index :users, :email, unique: true
    add_index :users, :uid
  end
end
