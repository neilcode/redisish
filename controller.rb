class RedisishController
	def initialize(commands=ARGF, database=nil, view=nil)
		@commands = commands
		@database = database
		@view 		= view
	end

	def process_input
		until @commands.eof?
			current_command = parse_instruction(@commands.readline.chomp)
			action 			 = current_command.first
			key 				 = current_command[1]   || 'key not found'
			value				 = current_command.last || nil
			result 			 = 'error: no result'
			
			case action
			when 'END'
				exit
			when 'SET'
				@database.store(key, value.to_i)
			when 'UNSET'
				@database.wipe(key)
			when 'GET'
				target = @database.retrieve_record(key)
				if target[:record]
					@view.out(target[:record].value || 'NULL')
				else
					#@view.out("#{key} not found")
				end
			when 'NUMEQUALTO'
				@view.out(@database.keys_set_to(value.to_i))
			when 'BEGIN'
				changes = new_transaction
			when 'ROLLBACK'
				@view.out("NO TRANSACTION")
			else
				@view.out("unrecognized command #{action}")
			end
		end
	end
	
	private

	def parse_instruction(command)
		command.split(' ')
	end
	
	def new_transaction(pending_changes_from_parent_transaction={})
		uncommitted_changes = Hash[pending_changes_from_parent_transaction] 
		#make a copy to enable new changes to be separate from parent transaction in case of rollback
		current_command = ''
		until @commands.eof?
			current_command = parse_instruction(@commands.readline.chomp)
			action 			    = current_command.first
			key 				    = current_command[1]   || 'key not found'
			value				    = current_command.last || nil

			case action
			when 'SET'
				uncommitted_changes[key] = value
			when 'GET'
				if uncommitted_changes.keys.include?(key)
					@view.out(uncommitted_changes[key])
				else #check committed data in the database
					target = @database.retrieve_record(key)
					if target[:record]
						@view.out(target[:record].value || 'NULL')
					end
				end
			when 'UNSET'
				uncommitted_changes[key] = nil
			when 'NUMEQUALTO'
				num_from_db = @database.keys_set_to(value.to_i)
				num_from_transaction = uncommitted_changes.values.count(value.to_i)
				num_from_db + num_from_transaction
			when 'BEGIN'
				changes = new_transaction(uncommitted_changes)
				return changes if changes #bubble up if there's been a commit further down the call stack
			when 'ROLLBACK'
				return nil
			when 'COMMIT'
				return uncommitted_changes
			when 'END'
				exit
			end
		end
	end


end

