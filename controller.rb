class RedisishController
	def initialize(commands=[], database=nil, view=nil)
		@commands = commands
		@database = database
		@view 		= view
	end

	def parse_instruction(command_string)
		command_string = command_string.split(' ')
		#@commands.map! { |command| command.split(' ') }
	end

	def process_input
		until @commands.eof?
			this_command = parse_instruction(@commands.readline.chomp)
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
				#@view.out("getting #{key}")
				target = @database.retrieve_record(key)
				if target[:record]
					@view.out(target[:record].value || 'NULL')
				else
					#@view.out("#{key} not found")
				end
			when 'NUMEQUALTO'
				@view.out(@database.keys_set_to(value.to_i))
			when 'END'
				break
			else
				#@view.out(action)
			end
		end
	end
end

class Transaction
	def initialize(commands, view)
		@commands = commands
		@view     = view
		@transaction