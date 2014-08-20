class User < ActiveRecord::Base
  attr_accessible :email, :name, :token, :default_repo_id, :integration_token

  has_many :repos

  validates :email, :token, presence: true
  validates_uniqueness_of :integration_token, allow_nil: true


  def self.find_by_omniauth(auth)
    user = User.find_by_email(auth["info"]["email"])
    return User.create_with_omniauth(auth) unless user
    user.update_attributes(token: auth["credentials"]["token"])
    return user
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.email = auth["info"]["email"]
      user.token = auth["credentials"]["token"]
    end
  end
end
