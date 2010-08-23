require 'digest/sha1'

include Casein::ConfigHelper

$CASEIN_USER_ACCESS_LEVEL_ADMIN = 0
$CASEIN_USER_ACCESS_LEVEL_USER = 10

module Casein
  class User < ActiveRecord::Base
	
	  def self.table_name
      self.to_s.gsub("::", "_").tableize
    end
	
  	attr_accessor :form_password_confirmation
  	attr_accessor :updating_password
	  
  	validates_presence_of :login, :name, :email
  	validates_uniqueness_of :login
  	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	
  	validates_presence_of :form_password, :if => :validate_password?
    validates_presence_of :form_password_confirmation, :if => :validate_password?
  	validates_length_of :form_password, :minimum => 6, :if => :validate_password?
    validates_confirmation_of :form_password, :if => :validate_password?

    after_create :send_create_notification
    after_update :send_update_notification

  	def self.authenticate(login, pass)     
  		user = Casein::User.where(:login => login).first		
  		return nil if user.nil?		
  		return user if Casein::User.encrypt(pass, user.salt) == user.password
  		nil
  	end
	
  	def self.has_more_than_one_admin
      Casein::User.where(:access_level => $CASEIN_USER_ACCESS_LEVEL_ADMIN).count > 1
    end
	
  	def send_create_notification
      Casein::CaseinNotification.new_user_information(self, casein_config_hostname, @form_password).deliver
    end
  
    def send_update_notification
      if updating_password
        Casein::CaseinNotification.generate_new_password(self, casein_config_hostname, @form_password).deliver
      end
    end
  
    def validate_password?
      updating_password || new_record?
    end
  
  	def form_password
  		@form_password
  	end
  
  	def form_password=(pass)
  		@form_password = pass
  		return if pass.blank?
		
  		self.salt = Casein::User.random_string(10) if !self.salt?
  		self.password = Casein::User.encrypt(@form_password, self.salt)
  	end 
  
  	def generate_new_password
  		new_pass = Casein::User.random_string(6)
  		self.form_password = self.form_password_confirmation = new_pass
  		self.save
		
  		Casein::CaseinNotification.generate_new_password(self, casein_config_hostname, new_pass).deliver
  	end
	
  	def is_admin?
  	  access_level == $CASEIN_USER_ACCESS_LEVEL_ADMIN
  	end

  private
  
  	def self.random_string(length)
  		chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
  		random_str = ""
  		1.upto(length) { |i|
  			random_str << chars[rand(chars.size-1)]
  		}
  		random_str
  	end
  
  	def self.encrypt(pass, salt)
  		finalString = pass + 'casein' + salt
  		Digest::SHA1.hexdigest(finalString)
  	end
  
  end
end
