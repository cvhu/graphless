class Model < ActiveRecord::Base
  attr_accessible :name, :data_type, :user_id

  belongs_to :user
  has_many :mnodes, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :values, :dependent => :destroy

  def view 
  	return {
  		id: id,
  		name: name,
  		mnodes: mnodes.map{|mnode| mnode.widget}
  	}
  end

  def widget
  	return {
  		id: id,
  		name: name,
  		user: user.nil? ? nil : user.widget
  	}
  end

  def createMnodes(parentMnode)
  	root = self.mnodes.where(:parent_id => -1).first
  	unless root.nil?
	  	myMnodes = Mnode.where(:parent_id => root.id)
	  	myMnodes.each do |myMnode|
	  		newMnode = Mnode.create(model_id: parentMnode.model_id, parent_id: parentMnode.id, name: myMnode.name, data_type: myMnode.data_type)
	  		myMnode.createMnodes(newMnode)
	  	end
	end
  end
end
