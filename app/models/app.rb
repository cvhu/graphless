class App < ActiveRecord::Base
  attr_accessible :description, :name, :user_id

  belongs_to :user
  has_many :app_models, :dependent => :destroy
  has_many :models, :through => :app_models
  has_many :mnodes, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :values, :dependent => :destroy

  def widget
  	return {
  		:id => id,
  		:name => name,
  		:description => description
  	}
  end
end
