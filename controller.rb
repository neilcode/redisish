class ThumbtackController
	def initialize(commands=[], database=nil, view=nil)
		@commands = commands
		@database = database
		@view 		= view
	end

	def prepare_instructions
		@commands.map! { |command| command.split(' ') }
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
				@database.store(key, value.to_i)
			when 'UNSET'
				@database.wipe(key)
			when 'GET'
				@view.out(@database.retrieve_record(key)[:record].value || 'NULL')
			when 'NUMEQUALTO'
				@view.out(@database.keys_set_to(value.to_i))
			else
				#@view.out(action)
			end
		end
	end
end