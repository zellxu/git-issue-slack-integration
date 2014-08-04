class AddIntegrationTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :integration_token, :string
  end
end
