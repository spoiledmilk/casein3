module Casein
  class <%= class_name.pluralize %>Controller < Casein::CaseinController
  
    ## optional filters for defining usage according to casein_users access_levels
    # before_filter :needs_admin, :except => [:action1, :action2]
    # before_filter :needs_admin_or_current_user, :only => [:action1, :action2]
  
    def index
  		@<%= plural_name %> = <%= class_name %>.all
    end
  
    def show
      @<%= singular_name %> = <%= class_name %>.find(params[:id])
    end
 
    def new
    	@<%= singular_name %> = <%= class_name %>.new
    end

    def create
      @<%= singular_name %> = <%= class_name %>.new(params[:<%= singular_name %>])
    
      if @<%= singular_name %>.save
        flash[:notice] = '<%= singular_name.humanize.capitalize %> created'
        redirect_to casein_<%= plural_name %>_path
      else
        flash[:warning] = 'There were problems when trying to create a new <%= singular_name.humanize.downcase %>'
        render :action => :new
      end
    end
  
    def update
      @<%= singular_name %> = <%= class_name %>.find(params[:id])
    
      if @<%= singular_name %>.update_attributes(params[:<%= singular_name %>])
        flash[:notice] = '<%= singular_name.humanize.capitalize %> has been updated'
        redirect_to casein_<%= plural_name %>_path
      else
        flash[:warning] = 'There were problems when trying to update this <%= singular_name.humanize.downcase %>'
        render :action => :show
      end
    end
 
    def destroy
      @<%= singular_name %> = <%= class_name %>.find(params[:id])

      @<%= singular_name %>.destroy
      flash[:notice] = '<%= singular_name.humanize.capitalize %> has been deleted'
      redirect_to casein_<%= plural_name %>_path
    end
  
  end
end