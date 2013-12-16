class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :user_id
      t.integer :model_id
      t.integer :app_id

      t.timestamps
    end
  end
end
