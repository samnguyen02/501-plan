class AddRoleToAdmins < ActiveRecord::Migration[8.1]
     def up
          add_column :admins, :role, :string, null: false, default: "admin"
          add_index :admins, :role
     end

     def down
          remove_index :admins, :role
          remove_column :admins, :role
     end
end
