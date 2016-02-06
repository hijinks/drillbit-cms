require_dependency "drillbit/application_controller"

module Drillbit
	class UsersController < ApplicationController

		layout "drillbit/full_page"

		include Tokenable
		include KyruEmail
					
		def index
			@user = Drillbit::User.all
		end

		def new
			@user = Drillbit::User.new
		end

		def activate
			if (@user = Drillbit::User.load_from_activation_token(params[:id]))
				@user.activate!
				redirect_to(login_path, :notice => 'User was successfully activated.')
			else
				not_authenticated
			end
		end

		def create
			@user = Drillbit::User.new
			if user_params[:password] == user_params[:password_confirmation]
				
				token = generate_token('activation_token', User)
				
				@user.email = user_params[:email]
				@user.activation_token = token
				@user.activation_token_expires_at = Date.today + 7.days
				@user.password = user_params[:password]
				@user.password_confirmation = user_params[:password_confirmation]
				
				if @user.save
					activation_url = 'http://'+ request.host + '/activate/' + @user.activation_token
					send_activation(activation_url, user_params[:email])
					render :activation_notice
				else
					render :text => 'User registration failed'
				end
	
			else
				render :text => "Passwords do not match."
			end
			
		end

		def show

		end

		def edit
			@user = Drillbit::User.find(params[:id])
		end

		def update

		end

		def destroy
			@user = Drillbit::User.find(params[:id])
			@user.destroy
		end
		
		private
		
		def user_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
		
	end
end
