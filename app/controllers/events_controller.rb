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
			if user.nil?
				obj[:message] = 'Invalid key_public'
			else
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

end
