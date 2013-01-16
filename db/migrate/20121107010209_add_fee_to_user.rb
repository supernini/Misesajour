class AddFeeToUser < ActiveRecord::Migration
  def change
    add_column :users, :fee, :integer
  end
end
