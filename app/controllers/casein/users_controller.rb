class Casein::UsersController < Casein::CaseinController
 
  before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
  before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
  def index
		if request.get?
			@casein_page_title = "Users"
    	@users = CaseinUser.paginate :all, :order => :login, :page => params[:page]
		end
  end
 
  def new
		if request.get?
			@casein_page_title = "Add a new user"
    	@casein_user = CaseinUser.new
		end
  end
  
  def create
    if request.post?
      @casein_user = CaseinUser.new(params[:casein_user])
      
      unless @casein_user.save
        flash[:warning] = "There were problems when trying to create a new user"
        render :action => :new
        return
      end
      
      flash[:notice] = "An email has been sent to " + @casein_user.name + " with the new account details"
    end
    
    redirect_to casein_users_path
  end
  
  def show
		if request.get?
    	@casein_user = CaseinUser.find_by_id params[:id]
    
	    if @casein_user.nil?
	      redirect_to casein_users_path
	    end

			@casein_page_title = @casein_user.name + " | View User"
		end
  end
 
  def update
     if request.put?
        @casein_user = CaseinUser.find_by_id params[:id]
       
        if @casein_user
	
					@casein_page_title = @casein_user.name + " | Update User"
	
          unless @casein_user.update_attributes params[:casein_user]
            flash[:warning] = "There were problems when trying to update this user"
            render :action => :show
            return
          end
          flash[:notice] = @casein_user.name + " has been updated"
        end
      end

      if @session_user.is_admin?
        redirect_to casein_users_path
      else
        redirect_to :controller => :casein, :action => :index
      end
  end
 
  def update_password
    if request.put?
      
      @casein_user = CaseinUser.find_by_id params[:id]
      
      if @casein_user
	
        @casein_page_title = @casein_user.name + " | Update Password"
        user_to_update = CaseinUser.authenticate @casein_user.login, params[:form_current_password]
      
        unless user_to_update
          flash[:warning] = "The current password is incorrect"
          render :action => :show
          return
        else
          @casein_user = user_to_update
          @casein_user.updating_password = true
          unless @casein_user.update_attributes params[:casein_user]
            flash[:warning] = "There were problems when trying to change the password"
            render :action => :show
            return
          else
            flash[:notice] = "Password has been changed and a notification sent to " + @casein_user.email
          end
        end
      end
    end
    
    redirect_to casein_users_path
  end
 
  def reset_password
    if request.put?
      @casein_user = CaseinUser.find_by_id params[:id]
      
      if @casein_user
	
				@casein_page_title = @casein_user.name + " | Reset Password"
        @casein_user.updating_password = true

        unless @casein_user.update_attributes params[:casein_user]
          flash[:warning] = "There were problems when trying to reset this user's password"
          render :action => :show
          return
        end
        flash[:notice] = "Password has been reset and " + @casein_user.name + " has been notified by email"
      end
    end
    
    redirect_to casein_users_path
  end
 
  def destroy
    
    if request.delete?
      user = CaseinUser.find_by_id params[:id]
        
      if user
        if user.is_admin? == false || CaseinUser.has_more_than_one_admin
          
          if user.id == @session_user.id
            clear_session_and_cookies
          end
          
          flash[:notice] = user.name + " has been deleted"
          user.destroy
        end
      end
    end
    
    redirect_to casein_users_path
  end
 
end
