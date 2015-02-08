require_relative 'controller'
require_relative 'model'
require_relative 'view'
require_relative 'testdata'


database   = RedisishDatabase.new
view       = View.new
controller = ThumbtackController.new(SMALLSET, database, view)
controller.prepare_instructions
controller.process