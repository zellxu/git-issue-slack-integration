class Repo < ActiveRecord::Base
  attr_accessible :user_id, :name, :owner, :short_name
end
