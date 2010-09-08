module Casein
  module CaseinHelper
	
	  def casein_get_version_info  
	    YAML::load_file File.join(File.dirname(__FILE__), '..', '..', '..', 'PUBLIC_VERSION.yml')
	  end
	
  	def casein_get_full_version_string
  	  version_info = casein_get_version_info
  	  "v.#{version_info['major']}.#{version_info['minor']}.#{version_info['patch']}"
  	end
	
  	def casein_get_short_version_string
  	  version_info = casein_get_version_info
  	  "v.#{version_info['major']}"
  	end
	
  	def casein_generate_page_title
		
  		if @casein_page_title.nil?
  			return casein_config_website_name
  		end
		
  		@casein_page_title + " > " + casein_config_website_name
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
	
  	def casein_table_cell_link contents, link, options = {}
	  
  	  if options.key? :casein_truncate
  	    contents = truncate(contents, :length => options[:casein_truncate], :omission => "...")
  	  end
	  
    	link_to "#{contents}".html_safe, link, options
    end
    
    def casein_table_cell_no_link contents, options = {}
	  
  	  if options.key? :casein_truncate
  	    contents = truncate(contents, :length => options[:casein_truncate], :omission => "...")
  	  end
	  
    	"<div class='noLink'>#{contents}</div>".html_safe
    end
	
  	def casein_show_icon icon_name
  		"<div class='icon'><img src='/casein/images/icons/#{icon_name}.png' alt='' /></div>".html_safe
  	end
	
  	def casein_show_row_icon icon_name
  		"<div class='iconRow'><img src='/casein/images/icons/#{icon_name}.png' alt='' /></div>".html_safe
  	end
	
  	# Styled form tag helpers
	
  	def casein_text_field form, obj, attribute, options = {}
  	  casein_form_tag_wrapper(form.text_field(attribute, strip_casein_options(options_hash_with_merged_classes(options, 'caseinTextField'))), form, obj, attribute, options).html_safe
  	end
	
  	def casein_password_field form, obj, attribute, options = {}
  		casein_form_tag_wrapper(form.password_field(attribute, strip_casein_options(options_hash_with_merged_classes(options, 'caseinTextField'))), form, obj, attribute, options).html_safe
  	end
	
  	def casein_text_area form, obj, attribute, options = {}
  	  casein_form_tag_wrapper(form.text_area(attribute, strip_casein_options(options_hash_with_merged_classes(options, 'caseinTextArea'))), form, obj, attribute, options).html_safe
  	end
	
  	def casein_text_area_big form, obj, attribute, options = {}
  	 casein_form_tag_wrapper(form.text_area(attribute, strip_casein_options(options_hash_with_merged_classes(options, 'caseinTextAreaBig'))), form, obj, attribute, options).html_safe
  	end
	
  	def casein_check_box form, obj, attribute, options = {}
  	  form_tag = form.check_box(attribute, strip_casein_options(options))
	  
  	  if options.key? :casein_box_label
  	    form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:casein_box_label]}</span></div>".html_safe
  	  end
	  
  	  casein_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
  	end
	
  	def casein_check_box_group form, obj, check_boxes = {}
      form_tags = ""
    
      for check_box in check_boxes
        form_tags += casein_check_box form, obj, check_box[0], check_box[1]
      end
    
      casein_form_tag_wrapper form_tag, form, obj, attribute, options
    end
	
  	def casein_radio_button form, obj, attribute, tag_value, options = {}
  	  form_tag = form.radio_button(obj, attribute, tag_value, strip_casein_options(options))
	  
  	  if options.key? :casein_button_label
  	    form_tag = "<div>" + form_tag + "<span class=\"rcText\">#{options[:casein_button_label]}</span></div>".html_safe
  	  end
	  
  	  casein_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
  	end
	
  	def casein_radio_button_group form, obj, radio_buttons = {}
      form_tags = ""
    
      for radio_button in radio_buttons
        form_tags += casein_radio_button form, obj, check_box[0], check_box[1], check_box[2]
      end
    
      casein_form_tag_wrapper(form_tag, form, obj, attribute, options).html_safe
    end
	
  	def casein_select form, obj, attribute, option_tags, options = {}
  		casein_form_tag_wrapper(form.select(attribute, option_tags, strip_casein_options(options), merged_class_hash(options, 'caseinSelect')), form, obj, attribute, options).html_safe
  	end
  	
  	def casein_time_zone_select form, obj, attribute, option_tags, options = {}
  	  casein_form_tag_wrapper(form.time_zone_select(attribute, option_tags, strip_casein_options(options), merged_class_hash(options, 'caseinSelect')), form, obj, attribute, options).html_safe
  	end
	
  	def casein_collection_select form, obj, object, attribute, collection, value_method, text_method, options = {}
  		casein_form_tag_wrapper(collection_select(object, attribute, collection, value_method, text_method, strip_casein_options(options), merged_class_hash(options, 'caseinSelect')), form, obj, attribute, options).html_safe
  	end
  	
  	def casein_date_select form, obj, attribute, options = {}
  	  casein_form_tag_wrapper(form.date_select(attribute, strip_casein_options(options), merged_class_hash(options, 'caseinDateTimeSelect')), form, obj, attribute, options).html_safe
  	end

  	def casein_time_select form, obj, attribute, options = {}
  	  casein_form_tag_wrapper(form.time_select(attribute, strip_casein_options(options), merged_class_hash(options, 'caseinDateTimeSelect')), form, obj, attribute, options).html_safe
  	end
	
  	def casein_datetime_select form, obj, attribute, options = {}
  	  casein_form_tag_wrapper(form.datetime_select(attribute, strip_casein_options(options), merged_class_hash(options, 'caseinDateTimeSelect')), form, obj, attribute, options).html_safe
  	end
	
  	def casein_file_field form, obj, object_name, attribute, options = {}
  	  class_hash = merged_class_hash(options, 'caseinFileFieldContainer')
  	  contents = "<div class='#{class_hash[:class]}'>" + file_field(object_name, attribute, strip_casein_options(options)) + '</div>'
  	  casein_form_tag_wrapper(contents, form, obj, attribute, options).html_safe
  	end
	
  	def casein_hidden_field form, obj, attribute, options = {}
  	  form.hidden_field(attribute, strip_casein_options(options)).html_safe
  	end
	
  protected

    def strip_casein_options options
      options.reject {|key, value| key.to_s.include? "casein_" }
    end
    
    def merged_class_hash options, new_class
      if options.key? :class
        new_class += " #{options[:class]}"
      end
        
      {:class => new_class}
    end
    
    def options_hash_with_merged_classes options, new_class
      if options.key? :class
        new_class += " #{options[:class]}"
      end
      options[:class] = new_class
      options
    end

    def casein_form_tag_wrapper form_tag, form, obj, attribute, options = {}
        unless options.key? :casein_label
    		  human_attribute_name = attribute.to_s.humanize
        else
          human_attribute_name = options[:casein_label]
        end

    		html = "<p>"

        if obj && obj.errors[attribute].any?
    			html += "<span class='formError'>#{human_attribute_name} #{obj.errors[attribute].first}</span>".html_safe
    		else
    			html += form.label(attribute, human_attribute_name)
    		end

    		html += "</p>\n<p>#{form_tag}</p>"
    end
  end
end