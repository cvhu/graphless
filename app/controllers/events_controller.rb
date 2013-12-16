class EventsController < ApplicationController

	def view
		obj = {}
		obj[:status] = 'fail'
		event_id = params['event_id']
		if event_id.nil?
			obj[:message] = 'event_id is needed.'
		else
			event = Event.find_by_id(event_id)
			if event.nil?
				obj[:message] = 'Invalid event_id'
			else
				obj[:status] = 'success'
				obj[:event] = event.view
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
		app_id = params['app_id']
		if key_public.nil? or app_id.nil?
			obj[:message] = 'key_public is needed.'
		else
			app = App.find_by_id(app_id)
			user = User.find_by_key_public(key_public)
			if user.nil? or app.nil?
				obj[:message] = 'Invalid key_public'
			else
				obj[:status] = 'success'
				events = app.events.order('created_at asc')
				unless params[:offset].nil?
					events = events.offset(params[:offset].to_i)
				end
				unless params[:limit].nil?
					events = events.limit(params[:limit].to_i)
				end
				obj[:events] = events.map{|event| event.widget}
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
		model_id = params['model_id']
		app_id = params['app_id']
		contents = params['contents']
		mnodes = params['mnodes']
		if key_public.nil? or model_id.nil? or app_id.nil?
			obj[:message] = 'All key_public, model_id, app_id are needed.'
		else
			user = User.find_by_key_public(key_public)
			model = Model.find_by_id(model_id)
			app = App.find_by_id(app_id)
			if user.nil? or model.nil? or app.nil?
				obj[:message] = 'Invalid key_public, model_id, or app_id'
			else
				event = Event.create(user_id: user.id, model_id: model.id, app_id: app.id)
				if event.save
					n = contents.length - 1
					for i in 0..n
						content = contents[i]
						mnode_id = mnodes[i]
						mnode = Mnode.find(mnode_id)
						val = Value.create(content: content, data_type: mnode.data_type, mnode_id: mnode.id, event_id: event.id, model_id: model.id, app_id: app.id, user_id: user.id)
					end
					obj[:status] = 'success'
					obj[:event] = event.widget
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
