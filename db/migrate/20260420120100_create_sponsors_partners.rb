class CreateSponsorsPartners < ActiveRecord::Migration[8.1]
     def change
          create_table :sponsors_partners do |t|
               t.references :ideathon_year, null: false, foreign_key: true
               t.string :name, null: false
               t.string :job_title
               t.string :logo_url
               t.text :blurb
               t.boolean :is_sponsor, default: false, null: false

               t.timestamps
          end

          add_index :sponsors_partners, [ :ideathon_year_id, :name ]
     end
end
