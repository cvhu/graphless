class EventsController < ApplicationController

	def create
		obj = {}
		obj[:status] = 'fail'
		key_public = params['key_public']
		model_id = params['model_id']
		app_id = params['app_id']
		values = params['values']
		if key_public.nil? or model_id.nil? or app_id.nil? or values.nil?
			obj[:message] = 'All key_public, model_id, app_id, and values are needed.'
		else
			user = User.find_by_key_public(key_public)
			model = Model.find_by_id(model_id)
			app = App.find_by_id(app_id)
			if user.nil? or model.nil? or app.nil?
				obj[:message] = 'Invalid key_public, model_id, or app_id'
			else
				event = Event.create(user_id: user.id, model_id: model.id, app_id: app.id)
				if event.save
					values.each do |value|
						val = Value.create(content: value.content, data_type: value.data_type, mnode_id: value.mnode_id, event_id: event.id, model_id: model.id, app_id: app.id, user_id: user.id)
					end
				else
					obj[:status] = 'error'
					obj[:message] = 'There is an error creating the event.'
				end
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

end
