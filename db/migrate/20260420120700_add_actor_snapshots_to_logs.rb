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
          null_activity_log_count = select_value("SELECT COUNT(*) FROM activity_logs WHERE admin_id IS NULL").to_i
          null_manager_log_count = select_value("SELECT COUNT(*) FROM manager_action_logs WHERE admin_id IS NULL").to_i

          if null_activity_log_count.positive? || null_manager_log_count.positive?
               fallback_admin_id = select_value("SELECT id FROM admins ORDER BY id ASC LIMIT 1")
               if fallback_admin_id.blank?
                    raise ActiveRecord::IrreversibleMigration, "Cannot restore NOT NULL on log admin_id columns without at least one admin record."
               end

               execute <<~SQL
                 UPDATE activity_logs
                 SET admin_id = #{fallback_admin_id}
                 WHERE admin_id IS NULL
               SQL

               execute <<~SQL
                 UPDATE manager_action_logs
                 SET admin_id = #{fallback_admin_id}
                 WHERE admin_id IS NULL
               SQL
          end

          change_column_null :activity_logs, :admin_id, false
          change_column_null :manager_action_logs, :admin_id, false

          remove_column :activity_logs, :actor_name
          remove_column :activity_logs, :actor_email
          remove_column :manager_action_logs, :actor_name
          remove_column :manager_action_logs, :actor_email
     end
end
