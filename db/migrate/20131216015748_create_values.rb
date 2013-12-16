class CreateValues < ActiveRecord::Migration
  def change
    create_table :values do |t|
      t.integer :user_id
      t.integer :app_id
      t.integer :model_id
      t.integer :event_id
      t.integer :mnode_id
      t.string :data_type
      t.string :content

      t.timestamps
    end
  end
end
