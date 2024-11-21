class RenameLastActivityAtToLastInteractionAt < ActiveRecord::Migration[7.1]
  def change
    rename_column :carts, :last_activity_at, :last_interaction_at if column_exists?(:carts, :last_activity_at)
  end
end 