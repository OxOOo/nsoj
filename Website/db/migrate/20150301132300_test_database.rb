class TestDatabase < ActiveRecord::Migration
  def up
  	User.create!(:username=>"yuguotianqing", :password=>"abcdef", :password_confirmation=>"abcdef")
  end
  
  def down
  end
end
