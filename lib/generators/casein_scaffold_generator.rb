class CaseinScaffoldGenerator < Rails::Generators::NamedBase
  
  include Rails::Generators::Migration
  
  argument :attributes, :type => :array, :required => true, :desc => "required"
  class_options :create_model_and_migration => false
  
  def self.next_migration_number(dirname)
    if ActiveRecord::Base.timestamped_migrations
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    else
      "%.3d" % (current_migration_number(dirname) + 1)
    end
  end
  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end
  
  def generate_files
    template 'controller.rb', "app/controllers/casein/#{plural_name}_controller.rb"
    template 'views/index.html.erb', "app/views/casein/#{plural_name}/index.html.erb"
    template 'views/show.html.erb', "app/views/casein/#{plural_name}/show.html.erb"
    template 'views/new.html.erb', "app/views/casein/#{plural_name}/new.html.erb"
    template 'views/_fields.html.erb', "app/views/casein/#{plural_name}/_fields.html.erb"
    add_to_routes_namespace
    add_to_routes
    add_to_navigation
    if options[:create_model_and_migration]
      template 'model.rb', "app/models/#{singular_name}.rb"
      migration_template 'migration.rb', "db/migrate/create_#{plural_name}.rb"
    end
  end
  
  protected
  
  def add_to_navigation
    file_to_update = 'app/views/casein/layouts/_left_navigation.html.erb'
    line_to_add = "<li id=\"visitSite\"><%= link_to \"#{plural_name.humanize.capitalize}\", casein_#{plural_name}_path %></li>"
    insert_sentinel = '<!-- SCAFFOLD_INSERT -->'
    gsub_add_once plural_name, file_to_update, line_to_add, insert_sentinel
  end
  
  #replacement for standard Rails generator route_resources. This one only adds once
  def add_to_routes_namespace
    file_to_update = Rails.root+'config/routes.rb'
    line_to_add = "namespace :casein do"
    insert_sentinel = 'Application.routes.draw do |map|'
    if File.read(file_to_update).scan(/(#{Regexp.escape("#{line_to_add}")})/mi).blank?
      gsub_add_once plural_name, file_to_update, "  " + line_to_add + "\n  end", insert_sentinel
    end
  end
  def add_to_routes
    file_to_update = Rails.root+'config/routes.rb'
    line_to_add = "resources :#{plural_name}"
    insert_sentinel = 'namespace :casein do'
    gsub_add_once plural_name, file_to_update, "    " + line_to_add, insert_sentinel
  end
  
  def gsub_add_once m, file, line, sentinel
    unless options[:pretend]
      gsub_file file, /(#{Regexp.escape("\n#{line}")})/mi do |match|
        ''
      end
      gsub_file file, /(#{Regexp.escape(sentinel)})/mi do |match|
        "#{match}\n#{line}"
      end
    end
  end
  def gsub_file(path, regexp, *args, &block)
    content = File.read(path).gsub(regexp, *args, &block)
    File.open(path, 'wb') { |file| file.write(content) }
  end
  
  def field_type(type)
    case type.to_s.to_sym
      when :integer, :float, :decimal   then :text_field
      when :datetime, :timestamp, :time then :datetime_select
      when :date                        then :date_select
      when :string                      then :text_field
      when :text                        then :text_area
      when :boolean                     then :check_box
    else
      :text_field
    end      
  end
end
