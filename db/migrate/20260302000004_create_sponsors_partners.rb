class CreateSponsorsPartners < ActiveRecord::Migration[8.0]
  def change
    create_table :sponsors_partners do |t|
      t.integer :year, null: false
      t.string :name, null: false
      t.string :logo_url
      t.text :blurb
      t.boolean :is_sponsor, default: false
      t.timestamps
    end
    add_foreign_key :sponsors_partners, :ideathons, column: :year, primary_key: :year
    add_index :sponsors_partners, :year
  end
end
