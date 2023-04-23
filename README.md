# MetaLabs Coding Challenge

## Installation

```bash
This project uses Ruby version 3.1.2 and Ruby on Rails version 7.0.4.1

$ bundle install
$ rake db:create db:migrate
$ rake db:seed (optional)

# (for development environment)
# create a .env file in the root of the project, and add:
SECRET_KEY_BASE=[YOUR_SECRET]
```

## Running the app

```bash
# start server
$ rails s
```


## Web solution
```
# If seeds where added to the db, you can go to the main page and log in with this test user
email: test@test.com
password: testtest
```


## API usage

### Log in (returns a token used in headers for future requests)
```bash
$ curl -XPOST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"email":"[USER_EMAIL]", "password":"[USER_PASSWORD]"}'

# Example
$ curl -XPOST http://localhost:3000/api/auth/login -H "Content-Type: application/json" -d '{"email":"test@test.com", "password":"testtest"}'
> { "token": [TOKEN] }
```

### Get products
```bash
$  curl -XGET http://localhost:3000/api/products -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json"

# Example
> [{"name":"test name 1","price":"100.0"},{"name":"test name 2","price":"200.0"},{"name":"test name 3","price":"300.0"}]
```

### Show product
```bash
$  curl -XGET http://localhost:3000/api/products/[PRODUCT_ID] -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json"

# Example
$  curl -XGET http://localhost:3000/api/products/1 -H "Authorization: Bearer [TOKEN]"
> {"id":1,"name":"test name 1","description":"test description 1","price":"100.0","stock":2,"created_at":"2023-04-22T20:48:08.506Z",
"updated_at":"2023-04-23T00:59:33.772Z"}
```

### Show current user's cart
```bash
$  curl -XGET http://localhost:3000/api/user/cart -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json"

# Example
> {"products":[{"id":1,"name":"test name 1","description":"test description 1","price":"100.0","stock":4},{"id":2,"name":"test name 2","description":"test description 2","price":"200.0","stock":4}],"total_price":"300.0"}
```

### Add product to current user's cart
```bash
$  curl -XPOST http://localhost:3000/api/user/cart/add_product -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json" -d '{"product_id":[PRODUCT_ID]}'

# Example
$  curl -XPOST http://localhost:3000/api/user/cart/add_product -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json" -d '{"product_id":1}'
> [NO_CONTENT]
```

### Remove product from current user's cart
```bash
$  curl -XPOST http://localhost:3000/api/user/cart/remove_product -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json" -d '{"product_id":[PRODUCT_ID]}'

# Example
$  curl -XPOST http://localhost:3000/api/user/cart/remove_product -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json" -d '{"product_id":1}'
> [NO_CONTENT]
```

### Get current user's purchases
```bash
$  curl -XGET http://localhost:3000/api/user/purchases -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json"

# Example
> [{"id":8,"created_at":"2023-04-23T01:59:33.621Z","purchase_items":[{"name":"test name 2","price":"200.0","quantity":1}],"total_price":"200.0"},{"id":5,"created_at":"2023-04-22T23:25:30.627Z","purchase_items":[{"name":"test name 1","price":"100.0","quantity":1},{"name":"test name 3","price":"300.0","quantity":1}],"total_price":"400.0"}]
```


### Create a purchase for the current user
```bash
$  curl -XPOST http://localhost:3000/api/user/purchases -H "Authorization: Bearer [TOKEN]" -H "Content-Type: application/json"

# Example
> {"id":9,"created_at":"2023-04-23T03:30:51.897Z","purchase_items":[{"name":"test name 1","price":"100.0","quantity":1}],"total_price":"100.0"}
```
