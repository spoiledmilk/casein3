class CaseinScaffoldGenerator < Rails::Generators::NamedBase
  def self.source_root
    @source_root ||= File.expand_path('../templates', __FILE__)
  end
  def manifest
    record do |m|
      m.file "definition.txt", "definition.txt"
    end
  end
end
