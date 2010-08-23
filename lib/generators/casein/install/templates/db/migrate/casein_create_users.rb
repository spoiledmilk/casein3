class CaseinCreateUsers < ActiveRecord::Migration
  
  def self.up
    create_table :casein_users do |t|   
      t.string :login, :null => false
      t.string :name
      t.string :email
      t.string :password, :null => false
      t.string :salt, :null => false
      t.integer :access_level, :null => false, :default => 0
      t.timestamps
    end
  end
  
  def self.down
    drop_table :casein_users
  end
  
end
