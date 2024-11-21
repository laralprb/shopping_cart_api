# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Limpar produtos existentes
Product.destroy_all

# Criar produtos para teste
products = [
  { name: 'Samsung Galaxy S24 Ultra', price: 12999.99 },
  { name: 'iPhone 15 Pro Max', price: 14999.99 },
  { name: 'Xiamo Mi 27 Pro Plus Master Ultra', price: 999.99 },
  { name: 'Produto 1', price: 1.99 },
  { name: 'Produto 2', price: 2.99 },
  { name: 'Produto 3', price: 3.99 }
]

products.each do |product|
  Product.create!(product)
end

puts "Produtos criados com sucesso!"
puts "IDs dos produtos criados:"
Product.all.each do |product|
  puts "ID: #{product.id} - #{product.name} - R$ #{product.price}"
end
