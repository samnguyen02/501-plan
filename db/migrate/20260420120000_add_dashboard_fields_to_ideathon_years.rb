class AddDashboardFieldsToIdeathonYears < ActiveRecord::Migration[8.1]
     def change
          add_column :ideathon_years, :year, :integer
          add_column :ideathon_years, :theme, :string

          add_index :ideathon_years, :year, unique: true
     end
end
