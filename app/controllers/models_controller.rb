class ModelsController < ApplicationController

	def create
		obj = {}
		obj[:status] = 'fail'
		key_public = params['key_public']
		name = params['name']
		if key_public.nil? or name.nil?
			obj[:message] = 'Both key_public and name are needed.'
		else
			user = User.find_by_key_public(key_public)
			if user.nil?
				obj[:message] = 'Invalid key_public'
			else
				model = Model.create(name: name, data_type: 'compound', user_id: user.id)
				if model.save
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
