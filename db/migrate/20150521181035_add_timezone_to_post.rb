class AddTimezoneToPost < ActiveRecord::Migration
  def change
    add_column :posts, :timezone, :string
  end
end
