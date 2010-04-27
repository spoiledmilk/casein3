class Casein::AuthController < Casein::CaseinController
  
  layout "casein_auth"
 	skip_before_filter :authorize, :only => [:show, :login, :recover_password]
  
  def show
    
  end
  
	def login
  	user = CaseinUser.authenticate(params[:login], params[:form_password])
		if user
		  clear_session_and_cookies

			session[:casein_user_id] = user.id
			uri = session[:original_uri]
			session[:original_uri] = nil
			
			if params[:remember_me] 
				user_code = create_user_code user
				cookies[:remember_me_id] = { :value => user.id.to_s, :expires => 30.days.from_now }
				cookies[:remember_me_code] = { :value => user_code, :expires => 30.days.from_now }
			end
			
			redirect_to(uri || {:controller => :casein})
		else
			flash.now[:warning] = "Unknown login or incorrect password"
			render :action => :show
		end
	end
	
	def logout
		clear_session_and_cookies
		flash.now[:notice] = "You have been logged out"
		redirect_to(casein_auth_path)
	end
	
	def recover_password
		if request.post?
  
			@users = CaseinUser.find :all, :conditions => "email='#{params[:recover_email]}'"
  
			if @users.length > 0
				for user in @users
					user.generate_new_password
				end
				
				if @users.length > 1
					flash.now[:notice] = "Multiple accounts were found. Emails have been sent to " + params[:recover_email] + " with all of your new passwords"
				else
					flash.now[:notice] = "An email has been sent to " + params[:recover_email] + " with your new password"
				end
			else
				flash.now[:warning] = "There is no user with that email"
			end
		end 

		redirect_to(casein_auth_path)
	end
		
end