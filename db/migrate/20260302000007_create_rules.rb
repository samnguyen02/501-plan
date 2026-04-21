class CreateRules < ActiveRecord::Migration[8.0]
  def change
    create_table :rules do |t|
      t.integer :year, null: false
      t.text :rule_text, null: false
      t.timestamps
    end
    add_foreign_key :rules, :ideathons, column: :year, primary_key: :year
    add_index :rules, :year
  end
end
