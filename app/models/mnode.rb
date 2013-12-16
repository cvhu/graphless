class Mnode < ActiveRecord::Base
  attr_accessible :model_id, :parent_id, :name, :data_type

  belongs_to :app
  belongs_to :model
  has_many :values, :dependent => :destroy

  def widget
  	return {
  		id: id,
  		model_id: model_id,
  		parent_id: parent_id,
  		name: name,
  		data_type: data_type
  	}
  end

  def createMnodes(parentMnode)
  	mnodes = Mnode.where(:parent_id => parentMnode.id)
  	mnodes.each do |mnode|
  		newMnode = Mnode.create(model_id: parentMnode.model_id, parent_id: parentMnode.id, name: mnode.name, data_type: mnode.data_type)
  		mnode.createMnodes(newMnode)
  	end
  end

end
