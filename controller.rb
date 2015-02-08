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
				@view.out("setting #{key} to #{value}")
				@database.store(key, value.to_i)
			when 'UNSET'
				@view.out("UNsetting #{key}")
				@database.wipe(key)
			when 'GET'
				@view.out("getting #{key}")
				target = @database.retrieve_record(key)
				if target[:record]
					@view.out(target[:record].value || 'NULL')
				else
					@view.out("#{key} not found")
				end
			when 'NUMEQUALTO'
				@view.out("finding # of keys set to #{value}")
				@view.out(@database.keys_set_to(value.to_i))
			else
				#@view.out(action)
			end
		end
	end
end