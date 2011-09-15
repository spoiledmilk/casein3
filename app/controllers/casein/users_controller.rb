module Casein
  class UsersController < Casein::CaseinController

    unloadable
  
    before_filter :needs_admin, :except => [:show, :destroy, :update, :update_password]
    before_filter :needs_admin_or_current_user, :only => [:show, :destroy, :update, :update_password]
 
    def index
      @casein_page_title = "Users"
    	@users = Casein::User.paginate :order => "login", :page => params[:page]
    end
 
    def new
      @casein_page_title = "Add a new user"
    	@casein_user = Casein::User.new
    	@casein_user.time_zone = Rails.configuration.time_zone
    end
  
    def create
      @casein_user = Casein::User.new params[:casein_user]
    
      if @casein_user.save
        flash[:notice] = "An email has been sent to " + @casein_user.name + " with the new account details"
        redirect_to casein_users_path
      else
        flash.now[:warning] = "There were problems when trying to create a new user"
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
        flash.now[:warning] = "There were problems when trying to update this user"
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
       
      if @casein_user.valid_password? params[:form_current_password]
        if @casein_user.update_attributes params[:casein_user]
          flash.now[:notice] = "Your password has been changed"
        else
          flash.now[:warning] = "There were problems when trying to change the password"
        end
      else
        flash.now[:warning] = "The current password is incorrect"
      end
      
      render :action => :show
    end
 
    def reset_password
      @casein_user = Casein::User.find params[:id]
      @casein_page_title = @casein_user.name + " | Reset Password"
       
      @casein_user.notify_of_new_password = true unless @casein_user.id == @session_user.id
      
      if @casein_user.update_attributes params[:casein_user]
        if @casein_user.id == @session_user.id
          flash.now[:notice] = "Your password has been reset"
        else    
          flash.now[:notice] = "Password has been reset and " + @casein_user.name + " has been notified by email"
        end
        
      else
        flash.now[:warning] = "There were problems when trying to reset this user's password"
      end
      render :action => :show
    end
 
    def destroy
      user = Casein::User.find params[:id]
      if user.is_admin? == false || Casein::User.has_more_than_one_admin
        user.destroy
        flash[:notice] = user.name + " has been deleted"
      end
      redirect_to casein_users_path
    end
 
  end
end