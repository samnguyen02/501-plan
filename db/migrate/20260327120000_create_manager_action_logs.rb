class CreateManagerActionLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :manager_action_logs do |t|
      t.references :admin, null: false, foreign_key: true
      t.string :action, null: false
      t.string :record_type
      t.bigint :record_id
      t.jsonb :metadata, null: false, default: {}
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end

    add_index :manager_action_logs, %i[record_type record_id]
    add_index :manager_action_logs, :action
    add_index :manager_action_logs, :created_at
  end
end

