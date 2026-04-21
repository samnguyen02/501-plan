class CreateFaqs < ActiveRecord::Migration[8.0]
  def change
    create_table :faqs do |t|
      t.integer :year, null: false
      t.text :question, null: false
      t.text :answer, null: false
      t.timestamps
    end
    add_foreign_key :faqs, :ideathons, column: :year, primary_key: :year
    add_index :faqs, :year
  end
end
