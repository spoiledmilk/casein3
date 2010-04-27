require 'digest/sha1'

include CaseinConfigHelper

$CASEIN_USER_ACCESS_LEVEL_ADMIN = 0
$CASEIN_USER_ACCESS_LEVEL_USER = 10

class CaseinUser < ActiveRecord::Base
	
	attr_accessor :form_password_confirmation
	
	attr_accessor :updating_password
	  
	validates_presence_of :login, :name, :email
	validates_uniqueness_of :login
	validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	
	validates_presence_of :form_password, :if => :validate_password?
  validates_presence_of :form_password_confirmation, :if => :validate_password?
	validates_length_of :form_password, :minimum => 6, :if => :validate_password?
  validates_confirmation_of :form_password, :if => :validate_password?

	def self.authenticate(login, pass)     
		user = find(:first, :conditions => ["login = ?", login])		
		return nil if user.nil?		
		return user if CaseinUser.encrypt(pass, user.salt) == user.password
		nil
	end
	
	def self.has_more_than_one_admin
    CaseinUser.count(:conditions => "access_level=#{$CASEIN_USER_ACCESS_LEVEL_ADMIN}") > 1
  end
	
	def after_create
    CaseinNotification.deliver_new_user_information(self, casein_config_hostname, @form_password)
  end
  
  def after_update
    if updating_password
      CaseinNotification.deliver_generate_new_password(self, casein_config_hostname, @form_password)
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
		
		self.salt = CaseinUser.random_string(10) if !self.salt?
		self.password = CaseinUser.encrypt(@form_password, self.salt)
	end 
  
	def generate_new_password
		new_pass = CaseinUser.random_string(6)
		self.form_password = self.form_password_confirmation = new_pass
		self.save
		
		CaseinNotification.deliver_generate_new_password(self, casein_config_hostname, new_pass)
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
