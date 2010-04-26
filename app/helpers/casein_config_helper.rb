module CaseinConfigHelper
  
	# Text string containing the name of the website or client
	# Used in text and titles throughout Casein
  def casein_config_website_name
  	'Casein'
  end

	# URL to the logo used for the login screen and top banner - it should be a transparent PNG
  def casein_config_logo
  	'/casein/images/casein.png'
  end

	# The server hostname where Casein will run
  def casein_config_hostname
    if ENV['RAILS_ENV'] == 'production'
      'http://www.caseincms.com'
    else
      'http://localhost:3000'
    end
  end

	# The sender email address used for notifications
	def casein_config_email_from_address
		'donotreply@caseincms.com'
	end
	
	# The page that the user is shown when they login or click the logo
	# do not point this at casein/index!
	def casein_config_dashboard_url
		url_for :controller => :casein, :action => :blank
	end
	
	# A list of stylesheet files to include in the page head section
	def casein_config_stylesheet_includes
		['/casein/stylesheets/custom.css', '/casein/stylesheets/screen.css', '/casein/stylesheets/elements.css']
	end
	
	# A list of JavaScript files to include in the page head section
	def casein_config_javascript_includes
	 	['/casein/javascripts/custom.js', '/casein/javascripts/casein.js', '/javascripts/prototype.js']
	end

end