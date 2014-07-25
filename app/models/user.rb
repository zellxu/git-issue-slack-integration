class User < ActiveRecord::Base
  attr_accessible :token, :username

  has_many :repos

  validates :username, :token, presence: true
  
end
