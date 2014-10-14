module Drillbit
	class ApplicationController < ActionController::Base
		protect_from_forgery

		before_filter :require_login, :except => [:not_authenticated]
		
		layout "drillbit/full_page"
		
		protected
		
		def not_authenticated
			redirect_to '/admin/login' , :alert => "Please login first."
		end
  		
		def index

		end

	end
end