class Repo < ActiveRecord::Base
  attr_accessible :user_id, :name, :owner, :short_name

  validates :name, :owner, presence: true
  validates :short_name, presence: true, format: {with: /^[a-zA-Z]*$/}
  validates_uniqueness_of :short_name, scope: [:user_id]
  validates_uniqueness_of :name, scope: [:user_id, :owner], message: "for this repo has already been added"
end
