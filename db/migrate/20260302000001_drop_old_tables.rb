class DropOldTables < ActiveRecord::Migration[8.0]
  def up
    drop_table :judges if ActiveRecord::Base.connection.table_exists?(:judges)
    drop_table :books if ActiveRecord::Base.connection.table_exists?(:books)
    drop_table :attendances if ActiveRecord::Base.connection.table_exists?(:attendances)
  end

  def down
    create_table :judges do |t|
      t.string :judge_name, null: false
      t.string :judge_title, null: false
      t.text :judge_bio, null: false
      t.integer :ideathon, null: false
      t.timestamps
    end
  end
end
