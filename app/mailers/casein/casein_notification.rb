module Casein
  
  require 'casein/config_helper'
	include Casein::ConfigHelper
	  
  class CaseinNotification < ActionMailer::Base
	
  	default :from => casein_config_email_from_address
	
  	self.prepend_view_path File.join(File.dirname(__FILE__), '..', 'views', 'casein')
	
  	def generate_new_password casein_user, host, pass
  		@name = casein_user.name
  		@host = host
  		@login = casein_user.login
  		@pass = pass
  		@from_text = casein_config_website_name
  		
  		mail(:to => casein_user.email, :subject => "[#{casein_config_website_name}] New password")
  	end
  
  	def new_user_information casein_user, host, pass
      @name = casein_user.name
  		@host = host
  		@login = casein_user.login
  		@pass = pass
  		@from_text = casein_config_website_name
  		
  		mail(:to => casein_user.email, :subject => "[#{casein_config_website_name}] New user account")
  	end

  end
end