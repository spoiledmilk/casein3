namespace :casein do
  
  desc "Copies files for Casein"
  task :install => :environment do
    FileUtils::Verbose.mkdir_p "app/views/casein/layouts"
    
    FileUtils::Verbose.mkdir_p "db/migrate"
    
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/helpers/casein_config_helper.rb", "app/helpers/casein_config_helper.rb"
    
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/views/casein/layouts/_navigation.html.erb", "app/views/casein/layouts/_navigation.html.erb"
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/views/casein/layouts/_right_navigation.html.erb", "app/views/casein/layouts/_right_navigation.html.erb"
		
		FileUtils::Verbose.cp "vendor/plugins/casein3/db/migrate/casein_create_users.rb", "db/migrate/casein_create_users.rb"
		
		FileUtils::Verbose.cp_r "vendor/plugins/casein3/public/casein", "public/"
		
		puts "**"
		puts "** Additional icons can be downloaded from FamFamFam and should be placed in the public/casein/images/icons directory **"
		puts "** http://www.famfamfam.com/lab/icons/silk/ **"
  end
end