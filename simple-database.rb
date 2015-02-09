require_relative 'controller'
require_relative 'model'
require_relative 'view'
require_relative 'testdata'

user_input = ARGF


view       = View.new
database   = RedisishDatabase.new
controller = RedisishController.new(user_input, database, view)

controller.process_input

#WIP: 
# create some datastructure to store offsets so that NUMEQUALTO works inside a transaction.
# currently, if there are 3 records set to '10' and a transaction is started, no matter what's done
# to those records, NUMEQUALTO always returns '3' because it polls the database first. if there were 
# a collection of values stored in the transaction that offsets the 'NUMEQUALTO' to display the right
# number, that'd be good. Offsets would have to be stored for SET & UNSET

# COMMIT all transactional data to the actual db. this should be easy-ish.