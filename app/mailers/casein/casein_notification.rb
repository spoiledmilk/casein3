module Casein
  
  class CaseinNotification < ActionMailer::Base
	
  	self.prepend_view_path File.join(File.dirname(__FILE__), '..', 'views', 'casein')
	
  	def generate_new_password from, casein_user, host, pass
  		@name = casein_user.name
  		@host = host
  		@login = casein_user.login
  		@pass = pass
  		@from_text = casein_config_website_name
  		
  		mail(:to => casein_user.email, :from => from, :subject => "[#{casein_config_website_name}] New password")
  	end
  
  	def new_user_information from, casein_user, host, pass
      @name = casein_user.name
  		@host = host
  		@login = casein_user.login
  		@pass = pass
  		@from_text = casein_config_website_name
  		
  		mail(:to => casein_user.email, :from => from, :subject => "[#{casein_config_website_name}] New user account")
  	end
  	
  	def password_reset_instructions from, casein_user, host
  	  ActionMailer::Base.default_url_options[:host] = host.gsub("http://", "")
      @name = casein_user.name
      @host = host
      @login = casein_user.login
      @reset_password_url = edit_casein_password_reset_url + "/?token=#{casein_user.perishable_token}"
      @from_text = casein_config_website_name

      mail(:to => casein_user.email, :from => from, :subject => "[#{casein_config_website_name}] Password reset instructions")
    end

  end
end