require_dependency "drillbit/application_controller"

module Drillbit
	class UsersController < ApplicationController

		layout "drillbit/full_page"
		
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
			@user = Drillbit::User.new(params[:user])
			
			
			if @user.save
				@profile = Profile.create(user_id: @user.id)
				render :message, :notice => "Signed up!"
			else
				render :new
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
		
		def save_params
			params.require(:user).permit(:email, :password, :password_confirmation)
		end
		
	end
end
