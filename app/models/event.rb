class Event < ActiveRecord::Base
  attr_accessible :app_id, :model_id, :user_id

  belongs_to :user
  belongs_to :app
  belongs_to :model
  has_many :values, :dependent => :destroy

  def widget
  	return {
  		id: id
  	}
  end

  def view
  	return {
  		id: id,
  		mnodes: model.mnodes.map{|mnode| mnode.widget},
  		values: values.map{|value| value.widget}
  	}
  end

end