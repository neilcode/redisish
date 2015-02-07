FROM_ARGF = [
	'SET neil 5',
	'SET neil 10', 
	'SET elisse 15', 
	'BEGIN', 
	'SET elisse 20',
	'UNSET neil', 
	'ROLLBACK', 
	'GET elisse', 
	'SET elisse 2', 
	'COMMIT', 
	'SET elisse 30', 
	'GET elisse', 
	'ROLLBACK', 
	'END', 
	'GET elisse', 
	'END'
]

SMALLSET = ['SET neil 5', 'SET elisse 5', 'GET neil', 'NUMEQUALTO 5', 'UNSET neil', 'GET neil']
class DatabaseController
	def initialize(commands=[], database=Database.new, view=View.new)
		@commands = commands
		@database = database
		@view 		= view
	end

	def prepare_instructions
		@commands.map! { |command| command.split(' ') }
		@view.out("converting instructions...")
	end

	def process
		until @commands.empty?
			this_command = @commands.shift
			p "processing: #{this_command}\n"
			action 			 = this_command.first
			key 				 = this_command[1]   || 'key not found'
			value				 = this_command.last || nil
			result 			 = 'error: no result'
			
			case action
			when 'SET'
				@database.store(key, value)
			when 'UNSET'
				@database.wipe(key)
			when 'GET'
				@view.out(@database.retrieve(key))
			when 'NUMEQUALTO'

				@view.out(@database.keys_set_to(value))
			else
				#@view.out(action)
			end
		end
	end
end
	

class Database
	def initialize
		@storage = {}
		@frequencymap = {}
	end

	def store(key, value)
		value = value.to_i
		@storage.store(key, value)
		if @frequencymap[value]
			@frequencymap[value] += 1
		else
			@frequencymap[value] = 1
		end
	end

	def wipe(key)
		if @storage[key]
			@frequencymap[self.retrieve(key)] -= 1
			@storage[key] = nil
		else
			@storage[key] = nil
		end
	end

	def retrieve(key)
		if @storage[key]
			return @storage[key]
		else
			return "NULL"
		end
	end

	def keys_set_to(value)
		value = value.to_i
		@frequencymap[value]
	end
end


class View
	def out(data)
		print data.to_s + "\n"
	end
end			
	
starterdb  = Database.new
controller = DatabaseController.new(SMALLSET, starterdb)
controller.prepare_instructions
controller.process





