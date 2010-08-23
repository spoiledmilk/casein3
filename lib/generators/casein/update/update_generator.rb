module Casein
  class UpdateGenerator < Rails::Generators::Base
    
      source_root File.expand_path('../templates', __FILE__)
      
      def generate_files
        puts "*** Updating Casein public assets. These should not be modified as they may be overwritten in future updates. ***"

        #stylesheets
  			copy_file "public/casein/stylesheets/screen.css", "public/casein/stylesheets/screen.css"
  			copy_file "public/casein/stylesheets/elements.css", "public/casein/stylesheets/elements.css"
  			copy_file "public/casein/stylesheets/login.css", "public/casein/stylesheets/login.css"

  			#javascripts
  			copy_file "public/casein/javascripts/casein.js", "public/casein/javascripts/casein.js"
  			copy_file "public/casein/javascripts/login.js", "public/casein/javascripts/login.js"
  			copy_file "public/casein/javascripts/jquery.js", "public/casein/javascripts/jquery.js"
  			copy_file "public/casein/javascripts/rails.js", "public/casein/javascripts/rails.js"

        #images
        copy_file "public/casein/images/header.png", "public/casein/images/header.png"
        copy_file "public/casein/images/nav.png", "public/casein/images/nav.png"
        copy_file "public/casein/images/rightNav.png", "public/casein/images/rightNav.png"
        copy_file "public/casein/images/rightNavButton.png", "public/casein/images/rightNavButton.png"
        copy_file "public/casein/images/casein.png", "public/casein/images/casein.png"
        copy_file "public/casein/images/visitSiteNav.png", "public/casein/images/visitSiteNav.png"
  			copy_file "public/casein/images/login/top.png", "public/casein/images/login/top.png"
  		  copy_file "public/casein/images/login/bottom.png", "public/casein/images/login/bottom.png"

  			#icons
  			all_icons = Dir.new(File.expand_path('../templates/public/casein/images/icons/', __FILE__)).entries

  			for icon in all_icons
  				if File.extname(icon) == ".png"
  					copy_file "public/casein/images/icons/#{icon}", "public/casein/images/icons/#{icon}"
  				end
  			end
  		end
  end
end