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
end
