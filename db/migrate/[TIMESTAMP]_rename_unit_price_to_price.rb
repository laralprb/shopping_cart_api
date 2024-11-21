class RenameUnitPriceToPrice < ActiveRecord::Migration[7.1]
  def change
    rename_column :products, :unit_price, :price if column_exists?(:products, :unit_price)
    # Não renomear total_price para price no Cart
  end
end 