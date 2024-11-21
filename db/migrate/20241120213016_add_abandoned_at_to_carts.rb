class AddAbandonedAtToCarts < ActiveRecord::Migration[7.1]
  def up
    add_column :carts, :abandoned_at, :datetime unless column_exists?(:carts, :abandoned_at)
    add_index :carts, :abandoned_at unless index_exists?(:carts, :abandoned_at)
  end

  def down
    remove_index :carts, :abandoned_at if index_exists?(:carts, :abandoned_at)
    remove_column :carts, :abandoned_at if column_exists?(:carts, :abandoned_at)
  end
end
