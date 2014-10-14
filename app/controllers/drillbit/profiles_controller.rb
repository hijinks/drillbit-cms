require_dependency "drillbit/application_controller"

module Drillbit
  class ProfilesController < ApplicationController
  	layout "drillbit/full_page"

  	def show
		@user = Drillbit::User.find_by_id(current_user.id)
		
		uploader = AvatarUploader.new
		
		if @user
			@profile = @user.profile
		end
  	end
	
	def update
		@user = Drillbit::User.find_by_id(current_user.id)

  		
  		if @user
  			@profile = @user.profile
  			save_params = profile_params
   			save_params[:user_id] = current_user.id

  			uploader = AvatarUploader.new
  					 			
   			if @profile.update_attributes(save_params)
   				redirect_to :show_profile, :notice => "Profile saved"
   			else
   				redirect_to :show_profile, :alert => "Profile not saved"
   			end
  		end	
	end
	
	private

 	def profile_params
 		params.require(:profile).permit(:alias, :contact, :bio, :avatar, :location)
 	end

  end
end
