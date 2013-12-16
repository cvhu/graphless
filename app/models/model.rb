class Model < ActiveRecord::Base
  attr_accessible :name, :data_type, :user_id
end
