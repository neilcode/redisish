require_relative 'controller'
require_relative 'model'
require_relative 'view'
require_relative 'testdata'

user_input = ARGF


view       = View.new
database   = RedisishDatabase.new
controller = RedisishController.new(user_input, database, view)

controller.process_input