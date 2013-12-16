class CreateAppModels < ActiveRecord::Migration
  def change
    create_table :app_models do |t|
      t.integer :app_id
      t.integer :model_id

      t.timestamps
    end
  end
end
