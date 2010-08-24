module Casein
  class UserSession < ::Authlogic::Session::Base
    include ActiveModel::Conversion 
    def persisted? 
      false 
    end
  end
end