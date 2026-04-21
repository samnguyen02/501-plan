class AddActorSnapshotsToLogs < ActiveRecord::Migration[8.1]
     def up
          add_column :activity_logs, :actor_name, :string
          add_column :activity_logs, :actor_email, :string
          add_column :manager_action_logs, :actor_name, :string
          add_column :manager_action_logs, :actor_email, :string

          execute <<~SQL
            UPDATE activity_logs
            SET actor_name = COALESCE(admins.full_name, admins.email),
                actor_email = admins.email
            FROM admins
            WHERE activity_logs.admin_id = admins.id
          SQL

          execute <<~SQL
            UPDATE manager_action_logs
            SET actor_name = COALESCE(admins.full_name, admins.email),
                actor_email = admins.email
            FROM admins
            WHERE manager_action_logs.admin_id = admins.id
          SQL

          change_column_null :activity_logs, :admin_id, true
          change_column_null :manager_action_logs, :admin_id, true
     end

     def down
          change_column_null :activity_logs, :admin_id, false
          change_column_null :manager_action_logs, :admin_id, false

          remove_column :activity_logs, :actor_name
          remove_column :activity_logs, :actor_email
          remove_column :manager_action_logs, :actor_name
          remove_column :manager_action_logs, :actor_email
     end
end
