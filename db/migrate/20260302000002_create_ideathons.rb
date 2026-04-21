class CreateIdeathons < ActiveRecord::Migration[8.0]
  def up
    create_table :ideathons, id: false do |t|
      t.integer :year, null: false
      t.string :theme
      t.timestamps
    end
    execute "ALTER TABLE ideathons ADD PRIMARY KEY (year);"
  end

  def down
    drop_table :ideathons
  end
end
