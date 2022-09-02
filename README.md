# README

## Rails Engine

This project makes use of Ruby on Rails and a PostgreSQL database to deliver 13 API endpoints focusing on merchants and their items. Key components include API exposure, JSON serialization and thorough API testing.

* Ruby version: 2.7.4
* Rails version: 5.2.6

## Set Up

* Fork/clone this repo, enter into the main directory and run `bundle`.
* To create/reset database run `rake db:{drop,create,migrate,seed}`, then `rails db:schema:dump`. If this works, your database should be populated with items, merchants, invoices, etc.
* To test locally, run rails server with `rails s` and send API requests to the database using the endpoints enumerated below. All responses come in JSON format.

## V1 Endpoints (and Accepted Query Params)

* `GET /api/v1/merchants` - get all merchants
* `GET /api/v1/merchants/:merchant_id` - get one merchant
* `GET /api/v1/merchants/:merchant_id/items` - get all items for a given merchant ID
* `GET /api/v1/items` - get all items
* `GET /api/v1/items/:item_id` - get one item
* `POST /api/v1/items` - create an item
* `PATCH /api/v1/items/:item_id` - edit an item
* `DELETE /api/v1/items/:item_id` - delete an item
* `GET /api/v1/items/:item_id/merchant` - get the merchant data for a given item ID
* `GET /api/v1/merchants/find` - find one merchant search by name
  * params: `name`
* `GET /api/v1/merchants/find_all` - find all merchants search by name
  * params: `name`
* `GET /api/v1/items/find` - find one item search by name or max/min price
  * params: `name`
  * params: `min_price` and/or `max_price`
* `GET /api/v1/items/find_all` - find all items search by name or max/min price
  * params: `name`
  * params: `min_price` and/or `max_price`

## Limitations

Invalid endpoints will error out, such as:

* Missing or empty `find`/`find_all` query params
* Searching an item(s) with both name AND price query params

## Testing

### RSpec

To run RSpec tests enter `bundle exec rspec`. Sad path and edge case testing included.

### Postman

* [Postman test suite pt. 1](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection1.postman_collection.json)
* [Postman test suite pt. 2](https://backend.turing.edu/module3/projects/rails_engine_lite/RailsEngineSection2.postman_collection.json)

To run Postman tests copy the links above (or save the files) and import to Postman. Start the rails server in your terminal with `rails s`. Run the tests individually by opening an endpoint and clicking "Send" or run all tests with a Postman runner by starting a runner, drag/dropping the test suite, and clicking "Run".

### Gem Stack

Ruby/Rails, JSONAPI-serializer, FactoryBot, Faker, Rubocop, RSpec, SimpleCov...