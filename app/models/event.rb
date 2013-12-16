class Event < ActiveRecord::Base
  attr_accessible :app_id, :model_id, :user_id

  belongs_to :user_id
  belongs_to :app
  belongs_to :model
  has_many :values, :dependent => :destroy

end