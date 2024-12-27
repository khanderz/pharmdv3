class CreateAtsTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :ats_types do |t|
      t.string :ats_type_code
      t.string :ats_type_name
      t.string :domain_matched_url
      t.string :redirect_url
      t.string :post_match_url

      t.timestamps
    end
    add_index :ats_types, :ats_type_code, unique: true
  end
end
