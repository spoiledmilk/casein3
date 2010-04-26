class CaseinScaffoldGenerator < Rails::Generators::NamedBase
  def self.source_root
    @source_root ||= File.expand_path(File.join(File.dirname(__FILE__), 'templates'))
  end
  def create_controller
    template 'controller.rb', "app/controllers/casein/#{plural_name}_controller.rb"
  end
end
