class ThumbtackController
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