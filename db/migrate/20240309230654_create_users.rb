class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.string :user_type
      t.string :user_resume
      t.string :user_photo
      t.timestamp :user_last_login

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
