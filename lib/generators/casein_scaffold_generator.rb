class CaseinScaffoldGenerator < Rails::Generators::NamedBase
  argument :attributes, :type => :array, :required => true, :desc => "required"
  
  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end
  def generate_files
    template 'controller.rb', "app/controllers/casein/#{plural_name}_controller.rb"
    template 'views/index.html.erb', "app/views/casein/#{plural_name}/index.html.erb"
    template 'views/show.html.erb', "app/views/casein/#{plural_name}/show.html.erb"
    template 'views/new.html.erb', "app/views/casein/#{plural_name}/new.html.erb"
    template 'views/_fields.html.erb', "app/views/casein/#{plural_name}/_fields.html.erb"
  end
end
