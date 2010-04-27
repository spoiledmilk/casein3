class CaseinNotification < ActionMailer::Base
	
	self.template_root = File.join(File.dirname(__FILE__), '..', 'views')
	
	def generate_new_password(casein_user, host, pass, sent_at = Time.now)
	 
	  @headers = {}
	  @from = casein_config_email_from_address
	  @recipients = casein_user.email
	  @sent_on = sent_at
		@subject = "[#{casein_config_website_name}] New password"
		@from_text = casein_config_website_name
		
		body  :name => casein_user.name,
		      :host => host,
		      :login => casein_user.login,
		      :pass => pass
	end
  
	def new_user_information(casein_user, host, pass, sent_at = Time.now)

	    @headers = {}
  	  @from = casein_config_email_from_address
  	  @recipients = casein_user.email
  	  @sent_on = sent_at
  		@subject = "[#{casein_config_website_name}] New user account"
			@from_text = casein_config_website_name

  		body  :name => casein_user.name,
  		      :host => host,
  		      :login => casein_user.login,
  		      :pass => pass
	end

end
