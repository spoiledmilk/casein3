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
    if options[:create_model_and_migration]
      template 'model.rb', "app/models/#{singular_name}.rb"
      migration_template 'migration.rb', "db/migrate/create_#{plural_name}.rb"
    end
  end
  
  private
  
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
