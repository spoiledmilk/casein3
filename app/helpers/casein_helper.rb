module CaseinHelper
	
	def casein_get_full_version_string
	  "v.#{$CASEIN_MAJOR_VERSION}.#{$CASEIN_MINOR_VERSION}.#{$CASEIN_BUILD_INFO}"
	end
	
	def casein_get_short_version_string
	  "v.#{$CASEIN_MAJOR_VERSION}.#{$CASEIN_MINOR_VERSION}"
	end
	
	def casein_get_session_user
		CaseinUser.find_by_id(session[:casein_user_id])
	end
	
	def casein_generate_page_title
		
		if @casein_page_title.nil?
			return casein_config_website_name
		end
		
		@casein_page_title + " > " + casein_config_website_name
	end
	
	def casein_render_right_bar_partial
	  
	  view_filename = params[:controller] + "/_" + params[:action] + "_right_bar.html.erb"
	  
	  for path in ActionController::Base.view_paths
	    if File.exists?(path.to_s + "/" + view_filename)
	      return render(:file => view_filename, :locals => {:id => params[:id]})
  	  end
	  end

	  ""
	end
	
	def casein_get_access_level_text level
	  case level
      when $CASEIN_USER_ACCESS_LEVEL_ADMIN
        return "Administrator"
      when $CASEIN_USER_ACCESS_LEVEL_USER
	      return "User"
	    else
	      return "Unknown"
	  end
	end
	
	def casein_get_access_level_array
	  [["Administrator", $CASEIN_USER_ACCESS_LEVEL_ADMIN], ["User", $CASEIN_USER_ACCESS_LEVEL_USER]]
	end
		
	def casein_table_row_class_name row
		if row % 2 == 0
			return "even"
		else
			return ""
		end
	end
	
	def casein_table_cell_link contents, object, options = {}
	  
	  if options.key? :casein_truncate
	    contents = truncate(contents, :length => options[:casein_truncate], :omission => "...")
	  end
	  
  	link_to "#{contents}", :action => :show, :id => object.id
  end
	
	def casein_show_icon icon_name
		"<div class='icon'><img src='/casein/images/icons/#{icon_name}.png' alt='' /></div>"
	end
	
	def casein_show_row_icon icon_name
		"<div class='iconRow'><img src='/casein/images/icons/#{icon_name}.png' alt='' /></div>"
	end
	
	# Styled form tag helpers
	
	def casein_text_field form, model, attribute, options = {}
	  casein_form_tag_wrapper form.text_field(attribute, options.merge({:class => 'caseinTextField'})), form, model, attribute, options
	end
	
	def casein_password_field form, model, attribute, options = {}
		casein_form_tag_wrapper form.password_field(attribute, options.merge({:class => 'caseinTextField'})), form, model, attribute, options
	end
	
	def casein_text_area form, model, attribute, options = {}
	  casein_form_tag_wrapper form.text_area(attribute, options.merge({:class => 'caseinTextArea'})), form, model, attribute, options
	end
	
	def casein_text_area_big form, model, attribute, options = {}
	 casein_form_tag_wrapper form.text_area(attribute, options.merge({:class => 'caseinTextAreaBig'})), form, model, attribute, options
	end
	
	def casein_check_box form, model, attribute, options = {}
	  form_tag = form.check_box(attribute, options)
	  
	  if options.key? :casein_box_label
	    form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:casein_box_label]}</span></div>"
	  end
	  
	  casein_form_tag_wrapper form_tag, form, model, attribute, options
	end
	
	def casein_check_box_group form, model, check_boxes = {}
    form_tags = ""
    
    for check_box in check_boxes
      form_tags += casein_check_box form, model, check_box[0], check_box[1]
    end
    
    casein_form_tag_wrapper form_tag, form, model, attribute, options
  end
	
	def casein_radio_button form, model, attribute, tag_value, options = {}
	  form_tag = form.radio_button(model, attribute, tag_value, options)
	  
	  if options.key? :casein_button_label
	    form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:casein_button_label]}</span></div>"
	  end
	  
	  casein_form_tag_wrapper form_tag, form, model, attribute, options
	end
	
	def casein_radio_button_group form, model, radio_buttons = {}
    form_tags = ""
    
    for radio_button in radio_buttons
      form_tags += casein_radio_button form, model, check_box[0], check_box[1], check_box[2]
    end
    
    casein_form_tag_wrapper form_tag, form, model, attribute, options
  end
	
	def casein_select form, model, attribute, option_tags, options = {}
		casein_form_tag_wrapper form.select(attribute, option_tags, options, {:class => 'caseinSelect'}), form, model, attribute, options
	end
	
	def casein_collection_select form, model, object, attribute, collection, value_method, text_method, options = {}
		casein_form_tag_wrapper collection_select(object, attribute, collection, value_method, text_method, options, {:class => 'caseinSelect'}), form, model, attribute, options
	end
	
	def casein_datetime_select form, model, attribute, options = {}
	  options.merge!(:time => true)
	  casein_date_select form, model, attribute, options
	end
	
	def casein_date_select form, model, attribute, options = {}
	  content_for(:calendar_includes)	{calendar_date_select_includes "casein"}
	  eval("model.#{attribute.to_s} = Time.now") if eval("model.#{attribute.to_s}.nil?")
	  default_options = { :month_year => "label", :embedded => true, :clear_button => false }
	  contents = content_tag(:div, form.calendar_date_select(attribute, {:class => 'caseinDateSelect'}.reverse_merge!(default_options.merge!(options))), :class => 'caseinDateSelectWrapper')
	  casein_form_tag_wrapper contents, form, model, attribute, options
	end

	def casein_file_field form, model, object_name, attribute, options = {}
	  contents = '<div class="caseinFileFieldContainer">' + file_field(object_name, attribute, options) + '</div>'
	  casein_form_tag_wrapper contents, form, model, attribute, options
	end
	
	def casein_hidden_field form, model, attribute, options = {}
	  form.hidden_field model, attribute, options
	end
	
protected

  def casein_form_tag_wrapper form_tag, form, model, attribute, options = {}
      unless options.key? :casein_label
  		  human_attribute_name = attribute.to_s.humanize
      else
        human_attribute_name = options[:casein_label]
      end

  		html = "<p>"

      if model && model.errors.invalid?(attribute)
  			html += error_message_on(model, attribute, :prepend_text => "#{human_attribute_name} ")
  		else
  			html += form.label(attribute, human_attribute_name)
  		end

  		html += "</p>\n<p>#{form_tag}</p>"
  end

end