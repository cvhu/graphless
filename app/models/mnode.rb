class Mnode < ActiveRecord::Base
  attr_accessible :app_id, :model_id, :parent_id

  belongs_to :app
  belongs_to :model
  has_many :values, :dependent => :destroy

  def widget
  	return {
  		id: id,
  	}
  end

end
