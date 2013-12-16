class AppModel < ActiveRecord::Base
  attr_accessible :app_id, :model_id

  belongs_to :app
  belongs_to :model
end
