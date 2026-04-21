class CreateActivityLogs < ActiveRecord::Migration[8.1]
     def change
          create_table :activity_logs do |t|
               t.references :admin, null: false, foreign_key: true
               t.string :action, null: false
               t.string :content_type, null: false
               t.text :item_name, null: false
               t.text :message, null: false

               t.timestamps
          end

          add_index :activity_logs, :created_at, order: { created_at: :desc }
          add_index :activity_logs, :content_type
     end
end
