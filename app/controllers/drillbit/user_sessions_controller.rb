require_dependency "drillbit/application_controller"

module Drillbit
	class UserSessionsController < ApplicationController
		before_filter :require_login_from_http_basic, :only => [:login_from_http_basic]
		skip_before_filter :require_login, :only => [:new, :create]	

		def new
			@user = Drillbit::User.new
		end

		def create
			if @user = login(params[:email], params[:password])
				redirect_back_or_to(:landing)
			else
				flash.now[:alert] = "Login failed"
				render action: "new"
			end
		end

		def destroy
			logout
			redirect_to(:login, notice: 'Logged out!')
		end

	end
end
