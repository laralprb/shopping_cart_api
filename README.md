# Shopping Cart API

API REST para gerenciamento de carrinho de compras desenvolvida em Ruby on Rails.

## Depend�ncias

- Ruby 3.3.1
- Rails 7.1.2
- PostgreSQL 16
- Redis 7.0.15
- Sidekiq 7.3.5

## Configura��o do Ambiente

###1. Instala��o e inicializa��o do PostgreSQL
sudo apt update
sudo apt install postgresql-16
sudo service postgresql start

### 2. Instala��o, utiliza��o e configura��o do Redis
sudo apt install redis-server
wget https://download.redis.io/releases/redis-7.0.15.tar.gz
tar xzf redis-7.0.15.tar.gz
cd redis-7.0.15
make
sudo make install
sudo mkdir /etc/redis
sudo cp redis.conf /etc/redis/
redis-server /etc/redis/redis.conf

### 3. Configura��o do Projeto - Clonar o reposit�rio: 
git clone https://github.com/laralprb/shopping_cart_api.git
cd shopping_cart_api

### 4. Instalar depend�ncias
bundle install

### 5. Configurar banco de dados
rails db:create
rails db:migrate

###6. Iniciar os Servi�os

-Terminal 1: Servidor Rails
rails s

- Terminal 2: Sidekiq
bundle exec sidekiq

## Funcionalidades

### Produtos
- Listar produtos: `GET /products`
- Criar produto: `POST /products`
- Ver produto: `GET /products/:id`
- Atualizar produto: `PUT /products/:id`
- Remover produto: `DELETE /products/:id`

### Carrinho
- Ver carrinho: `GET /cart`
- Adicionar item: `POST /cart/add_items`
- Remover item: `DELETE /cart/:product_id`

## Exemplos de Uso

### Criar Produto
curl -X POST http://localhost:3000/products \
-H "Content-Type: application/json" \
-d '{
"product": {
"name": "Produto Teste",
"unit_price": 19.99
}
}'

### Adicionar ao Carrinho
curl -X POST http://localhost:3000/cart/add_items \
-H "Content-Type: application/json" \
-d '{
"product_id": 1,
"quantity": 2
}'

## Jobs em Background

O sistema utiliza Sidekiq para processar:
- Marca��o de carrinhos abandonados (ap�s 3 horas sem intera��o)
- Remo��o de carrinhos abandonados (ap�s 7 dias)

Executar todos os testes
bundle exec rspec