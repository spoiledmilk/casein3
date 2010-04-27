namespace :casein do
  
  
  desc "Copies files and creates admin"
  task :fast_setup => :environment do
    raise "Usage: specify email address, e.g. rake casein:create_admin email=mail@caseincms.com" unless ENV.include?("email")
    Rake::Task["casein:install"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["casein:create_admin"].invoke
  end

  
  desc "Copies files for Casein"
  task :install => :environment do
    FileUtils::Verbose.mkdir_p "app/views/casein/layouts"
    
    FileUtils::Verbose.mkdir_p "db/migrate"
    
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/helpers/casein_config_helper.rb", "app/helpers/casein_config_helper.rb"
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/helpers/casein_helper.rb", "app/helpers/casein_helper.rb"
    
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/views/casein/layouts/_left_navigation.html.erb", "app/views/casein/layouts/_left_navigation.html.erb"
    FileUtils::Verbose.cp "vendor/plugins/casein3/app/views/casein/layouts/_right_navigation.html.erb", "app/views/casein/layouts/_right_navigation.html.erb"
		
		FileUtils::Verbose.cp "vendor/plugins/casein3/db/migrate/casein_create_users.rb", "db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_casein_create_users.rb"
		
		FileUtils::Verbose.cp_r "vendor/plugins/casein3/public/casein", "public/"
		
		puts "**"
		puts "** Additional icons can be downloaded from FamFamFam and should be placed in the public/casein/images/icons directory **"
		puts "** http://www.famfamfam.com/lab/icons/silk/ **"
  end

  
  desc "Creates admin user"
  task :create_admin => :environment do
    raise "Usage: specify email address, e.g. rake casein:create_admin email=mail@caseincms.com" unless ENV.include?("email")
    CaseinUser.create( {:login => 'admin', :name => 'Admin', :email => ENV['email'], :access_level => $CASEIN_USER_ACCESS_LEVEL_ADMIN, :form_password_confirmation => 'password', :form_password => 'password'} )
    puts "[Casein] Created new admin user with login 'admin' and password 'password'"
  end
end