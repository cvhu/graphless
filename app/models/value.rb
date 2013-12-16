class Value < ActiveRecord::Base
  attr_accessible :app_id, :content, :data_type, :event_id, :mnode_id, :model_id, :user_id
end
