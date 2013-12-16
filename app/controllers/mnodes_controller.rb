class MnodesController < ApplicationController

	def create
		obj = {}
		obj[:status] = 'fail'
		key_public = params['key_public']
		app_id = params['app_id']
		model_id = params['model_id']
		parent_id = params['parent_id']
		name = params['name']
		data_type = params['data_type']
		if key_public.nil? or app_id.nil? or model_id.nil? or parent_id.nil? or name.nil? or data_type.nil?
			obj[:message] = 'All key_public, app_id, model_id, parent_id, name, and data_type are needed.'
		else
			user = User.find_by_key_public(key_public)
			app = App.find_by_id(app_id)
			model = Model.find_by_id(model_id)
			if user.nil? or app.nil? or model.nil?
				obj[:message] = 'Invalid key_public, app_id, or model_id'
			else
				mnode = Mnode.create(app_id: app.id, model_id: model.id, parent_id: parent_id, name: name, data_type: data_type)
				if mnode.save
					obj[:status] = 'success'
					obj[:mnode] = mnode.widget
				else
					obj[:status] = 'error'
					obj[:message] = 'There is an error creating mnode.'
				end
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

end
