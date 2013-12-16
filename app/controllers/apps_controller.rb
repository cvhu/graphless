class AppsController < ApplicationController

	def profile
		@app = App.find(params[:id])
		@model = @app.models.first
	end

	def new
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
				apps = user.apps.order('created_at desc')
				unless params[:offset].nil?
					apps = apps.offset(params[:offset].to_i)
				end
				unless params[:limit].nil?
					apps = apps.limit(params[:limit].to_i)
				end
				obj[:apps] = apps.map{|app| app.widget}
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
		model_id = params['model_id']
		description = params['description']
		if key_public.nil? or name.nil? or description.nil? or model_id.nil?
			obj[:message] = 'All key_public, name, model_id, and description are needed.'
		else
			user = User.find_by_key_public(key_public)
			if user.nil?
				obj[:message] = 'Invalid key_public'
			else
				model = Model.find_by_id(model_id)
				if model.nil?
					obj[:message] = 'Invalid model_id'
				else
					app = App.create(name: name, description: description, user_id: user.id)
					appModel = AppModel.create(app_id: app.id, model_id: model.id)
					if app.save and appModel.save
						obj[:status] = 'success'
						obj[:app] = app.widget
					else
						obj[:status] = 'error'
						obj[:message] = 'There is an error creating the app.'
					end
				end
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

end
