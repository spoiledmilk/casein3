module Casein
  class UsersController < Casein::CaseinController
  
    unloadable
  
    before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
    	@users = Casein::User.order(:login)
    end
 
    def new
      @casein_page_title = "Add a new user"
    	@casein_user = Casein::User.new
    end
  
    def create
      @casein_user = Casein::User.new params[:casein_user]
    
      if @casein_user.save
        flash[:notice] = "An email has been sent to " + @casein_user.name + " with the new account details"
        redirect_to casein_users_path
      else
        flash[:warning] = "There were problems when trying to create a new user"
        render :action => :new
      end
    end
  
    def show
    	@casein_user = Casein::User.find params[:id]
    	@casein_page_title = @casein_user.name + " | View User"
    end
 
    def update
      @casein_user = Casein::User.find params[:id]
      @casein_page_title = @casein_user.name + " | Update User"

      if @casein_user.update_attributes params[:casein_user]
        flash[:notice] = @casein_user.name + " has been updated"
      else
        flash[:warning] = "There were problems when trying to update this user"
        render :action => :show
        return
      end
      
      if @session_user.is_admin?
        redirect_to casein_users_path
      else
        redirect_to :controller => :casein, :action => :index
      end
    end
 
    def update_password
      @casein_user = Casein::User.find params[:id]
      @casein_page_title = @casein_user.name + " | Update Password"
    
      if user_to_update = Casein::User.authenticate(@casein_user.login, params[:form_current_password])
        @casein_user = user_to_update
        @casein_user.updating_password = true
        if @casein_user.update_attributes(params[:casein_user])
          flash[:notice] = "Password has been changed and a notification sent to " + @casein_user.email
        else
          flash[:warning] = "There were problems when trying to change the password"
        end
      else
        flash[:warning] = "The current password is incorrect"
      end
      
      render :action => :show
    end
 
    def reset_password
      @casein_user = Casein::User.find params[:id]
      @casein_page_title = @casein_user.name + " | Reset Password"
      
      @casein_user.updating_password = true
      if @casein_user.update_attributes params[:casein_user]
        flash[:notice] = "Password has been reset and " + @casein_user.name + " has been notified by email"
      else
        flash[:warning] = "There were problems when trying to reset this user's password"
      end
      render :action => :show
    end
 
    def destroy
      user = Casein::User.find params[:id]
      if user.is_admin? == false || Casein::User.has_more_than_one_admin
        clear_session_and_cookies if user.id == @session_user.id
        user.destroy
        flash[:notice] = user.name + " has been deleted"
      end
      redirect_to casein_users_path
    end
 
  end
end