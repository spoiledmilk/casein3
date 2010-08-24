include Casein::ConfigHelper

$CASEIN_USER_ACCESS_LEVEL_ADMIN = 0
$CASEIN_USER_ACCESS_LEVEL_USER = 10

module Casein
  class User < ActiveRecord::Base

	  def self.table_name
      self.to_s.gsub("::", "_").tableize
    end

    acts_as_authentic { |c| c.validate_email_field = false }
	 
    attr_accessor :notify_of_new_password
	 
    after_create :send_create_notification
    after_update :send_update_notification
    
    validates_presence_of :login, :name, :email
    validates_uniqueness_of :login
    validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	  
  	def self.has_more_than_one_admin
      Casein::User.where(:access_level => $CASEIN_USER_ACCESS_LEVEL_ADMIN).count > 1
    end
	
  	def send_create_notification
      Casein::CaseinNotification.new_user_information(self, casein_config_hostname, @password).deliver
    end
  
    def send_update_notification
      if notify_of_new_password
        notify_of_new_password = false
        Casein::CaseinNotification.generate_new_password(self, casein_config_hostname, @password).deliver
      end
    end
    
    def send_password_reset_instructions
      reset_perishable_token!
      Casein::CaseinNotification.password_reset_instructions(self, casein_config_hostname).deliver
    end
	
  	def is_admin?
  	  access_level == $CASEIN_USER_ACCESS_LEVEL_ADMIN
  	end
  
  end
end
