class Model < ActiveRecord::Base
  attr_accessible :name, :data_type, :user_id

  belongs_to :user
  has_many :mnodes, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :values, :dependent => :destroy

  def widget
  	return {
  		id: id,
  		name: name,
  		user: user.widget
  	}
  end

end
