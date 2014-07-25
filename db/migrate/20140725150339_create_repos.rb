class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.references :user
      t.string :owner
      t.string :name
      t.string :short_name

      t.timestamps
    end
  end
end
