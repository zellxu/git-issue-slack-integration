class AddDefaultRepoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :default_repo_id, :integer
  end
end
