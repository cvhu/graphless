class UsersController < ApplicationController

	def signup
		obj = {}
		obj[:status] = 'fail'
		if (params[:email].nil? or params[:first_name].nil? or params[:last_name].nil? or params[:password].nil? or params[:password_confirmation].nil? or params[:username].nil?)
			obj[:message] = 'One or more parameters are missing'
		else
			email = params[:email].downcase
			if not User.isEmailValid(email)
				obj[:message] = 'Invalid email address'
			else
				username = params[:username]
				if not User.isUsernameValid(username)
					obj[:message] = "Username '#{username}' exists"
				else
					user = User.new
					user.email = email
					user.username = username
					user.first_name = params[:first_name]
					user.last_name = params[:last_name]
					user.password = params[:password]
					user.password_confirmation = params[:password_confirmation]
					if user.save
						user.renewLogin
						obj[:status] = 'success'
						obj[:message] = "Welcome to Graphless, #{user.getFullName}!"
						obj[:key_public] = user.key_public
						obj[:username] = user.username
						obj[:fullname] = user.getFullName
					else
						obj[:status] = 'error'
						obj[:message] = 'There is an error creating your account.'
					end
				end
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

	def profile
		@user = User.find_by_username(params[:username])
	end

	def header
		obj = {}
		obj[:status] = 'fail'
		key_public = params[:key_public]
		if key_public.nil?
			obj[:message] = 'No user public key provided.'
		else
			user = User.find_by_key_public(key_public)
			if user.nil?
				obj[:message] = 'Invalid user public key.'
			else
				obj[:status] = 'success'
				obj[:fullname] = user.getFullName
				obj[:username] = user.username
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

	def widget
		obj = {}
		obj[:status] = 'fail'
		username = params[:username]
		if username.nil?
			obj[:message] = 'No username provided.'
		else
			user = User.find_by_username(username)
			if user.nil?
				obj[:message] = 'Invalid username.'
			else
				obj[:status] = 'success'
				obj[:user] = user.getWidgetData
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

	def login
		obj = {}
		obj[:status] = 'fail'
		email = params[:email].downcase
		password = params[:password]
		if email.nil? or password.nil?
			obj[:message] = 'Both email and password are needed.'
		else
			user = User.find_by_email(email)
			if user.nil?
				obj[:message] = "No account found with '#{email}'"
			else
				if user.authenticate(password)
					user.renewLogin
					obj[:status] = 'success'
					obj[:key_public] = user.key_public
					obj[:username] = user.username
					obj[:fullname] = user.getFullName
				else
					obj[:message] = 'Incorrect email/password combination.'
				end
			end
		end
		respond_to do |format|
			format.json {render :json => obj.to_json}
		end
	end

	def logout
	end

end
