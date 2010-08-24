module Casein
  class UserSessionsController < Casein::CaseinController
    
    unloadable
    
    skip_before_filter :authorise, :only => [:new, :create]
    before_filter :requires_no_session_user, :except => [:destroy]
  
    layout 'casein_auth'
  
    def new
      @user_session = Casein::UserSession.new
    end
  
    def create
      @user_session = Casein::UserSession.new params[:casein_user_session]
      if @user_session.save
        flash[:notice] = "Login successful"
        redirect_back_or_default :controller => :casein, :action => :index
      else
        render :action => :new
      end
    end
  
    def destroy
      current_user_session.destroy
      flash[:notice] = "Logout successful"
      redirect_back_or_default new_casein_user_session_url
    end

  private
  
    def requires_no_session_user
      if current_user
        redirect_to :controller => :casein, :action => :index
      end
    end

  end
end