class Login < ActiveRecord::Base
  attr_accessible :key, :password, :user
end
