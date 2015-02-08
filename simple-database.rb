require_relative 'controller'
require_relative 'model'
require_relative 'view'
require_relative 'testdata'

input = ARGF


database   = RedisishDatabase.new
view       = View.new
controller = RedisishController.new(input, database, view)

controller.process_input