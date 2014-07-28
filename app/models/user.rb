class User < ActiveRecord::Base
  attr_accessible :email, :token

  has_many :repos

  validates :email, :token, presence: true

  def self.find_by_omniauth(auth)
    user = User.find_by_email(auth["info"]["email"])
    user ? user : User.create_with_omniauth(auth)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      debugger
      user.token = auth["credentials"]["token"]
    end
  end
end
