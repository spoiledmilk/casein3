require "casein"
require "rails"

module Casein
  class Engine < Rails::Engine
    
    rake_tasks do
      load "railties/tasks.rake"
    end
    
  end
end