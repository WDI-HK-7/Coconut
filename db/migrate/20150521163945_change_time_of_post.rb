class ChangeTimeOfPost < ActiveRecord::Migration
  def up
    change_table :posts do |t|
      t.change :taken_at, :timestamptz
    end
  end

  def down
    change_table :posts do |t|
      t.change :taken_at, :datetime
    end
  end
end
