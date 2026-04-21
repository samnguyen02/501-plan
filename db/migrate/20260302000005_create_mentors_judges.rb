class CreateMentorsJudges < ActiveRecord::Migration[8.0]
  def change
    create_table :mentors_judges do |t|
      t.integer :year, null: false
      t.string :name, null: false
      t.string :photo_url
      t.text :bio
      t.boolean :is_judge, default: false
      t.timestamps
    end
    add_foreign_key :mentors_judges, :ideathons, column: :year, primary_key: :year
    add_index :mentors_judges, :year
  end
end
