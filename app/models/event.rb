class Event < ActiveRecord::Base
  attr_accessible :app_id, :model_id, :user_id
end
