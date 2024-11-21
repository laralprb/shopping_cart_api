class SetupCompleteCartStructure < ActiveRecord::Migration[7.0]
  def change
    # Drop tabelas existentes se necessário
    drop_table :cart_products if table_exists?(:cart_products)
    drop_table :carts if table_exists?(:carts)

    # Criar tabela products se não existir
    unless table_exists?(:products)
      create_table :products do |t|
        t.string :name, null: false
        t.decimal :unit_price, precision: 10, scale: 2, null: false
        t.timestamps
      end
    end

    # Criar tabela carts
    create_table :carts do |t|
      t.datetime :last_activity_at, null: false, default: -> { 'CURRENT_TIMESTAMP' }
      t.decimal :total_price, precision: 10, scale: 2, default: 0
      t.timestamps
    end

    add_index :carts, :last_activity_at

    # Criar tabela cart_products
    create_table :cart_products do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.timestamps
    end

    add_index :cart_products, [:cart_id, :product_id], unique: true
  end
end 