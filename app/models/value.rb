class Value < ActiveRecord::Base
  attr_accessible :app_id, :content, :data_type, :event_id, :mnode_id, :model_id, :user_id

  belongs_to :user
  belongs_to :app
  belongs_to :model
  belongs_to :mnode
  belongs_to :event

  def widget
  	return {
  		id: id,
  		mnode_id: mnode_id,
  		content: content
  	}
  end
  
end
