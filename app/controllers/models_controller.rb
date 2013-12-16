class ModelsController < ApplicationController

	def view
		obj = {}
		obj[:status] = 'fail'
		model_id = params['model_id']
		if model_id.nil?
			obj[:message] = 'model_id is needed.'
		else
			model = Model.find_by_id(model_id)
			if model.nil?
				obj[:message] = 'Invalid model_id'
			else
				obj[:status] = 'success'
				obj[:model] = model.view
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

	def list
		obj = {}
		obj[:status] = 'fail'
		key_public = params['key_public']
		if key_public.nil?
			obj[:message] = 'key_public is needed.'
		else
			user = User.find_by_key_public(key_public)
			if user.nil?
				obj[:message] = 'Invalid key_public'
			else
				obj[:status] = 'success'
				models = Model.where(:user_id => nil)
				models += user.models.order('created_at asc')
				unless params[:offset].nil?
					models = models.offset(params[:offset].to_i)
				end
				unless params[:limit].nil?
					models = models.limit(params[:limit].to_i)
				end
				obj[:models] = models.map{|model| model.widget}
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

	def create
		obj = {}
		obj[:status] = 'fail'
		key_public = params['key_public']
		name = params['name']
		property_names = params[:property_names]
		property_models = params[:property_models]
		if key_public.nil? or name.nil? or property_names.nil? or property_models.nil?
			obj[:message] = 'Both key_public and name are needed.'
		else
			user = User.find_by_key_public(key_public)
			if user.nil?
				obj[:message] = 'Invalid key_public'
			else
				model = Model.create(name: name, data_type: 'compound', user_id: user.id)
				mnode_root = Mnode.create(model_id: model.id, parent_id: -1, name: model.name, data_type: 'compound')
				if model.save and mnode_root.save
					n = property_names.length - 1
					for i in 0..n
						property_name = property_names[i]
						property_model_id = property_models[i]
						property_model = Model.find_by_id(property_model_id)
						property_mnode = Mnode.create(model_id: model.id, parent_id: mnode_root.id, name: property_name, data_type: property_model.data_type)
						property_model.createMnodes(property_mnode)
						puts "name: #{property_name}, model: #{property_model_id}"
					end
					obj[:status] = 'success'
					obj[:model] = model.widget
				else
					obj[:status] = 'error'
					obj[:message] = 'This is an error creating the model.'
				end
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

end
