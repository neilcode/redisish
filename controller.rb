class RedisishController
	def initialize(commands=ARGF, database=nil, view=nil)
		@commands = commands
		@database = database
		@view 		= view
		@transaction_stack = []
		@current_transaction = nil
	end


	def listen_for_input
		until @commands.eof?
			this_command = parse_instruction(@commands.readline.chomp)
			execute(this_command)
		end
	end			
			
private
	
	def any_open_transactions
		@transaction_stack.any?
	end

	def parse_instruction(command)
		command.split(' ')
	end

	def commit(data)
		data.export[:storage].each do |record|
			@database.store(record.key, record.value.to_i)
		end
	end

	def execute(command)
		action = command.first
		key 	 = command[1]   || 'key not found'
		value	 = command.last || nil
		
		case action
		when 'END'
			exit
		when 'SET'
			@database.store(key, value.to_i)
		when 'UNSET'
			@database.wipe(key)
		when 'GET'
			target = @database.retrieve_record(key)
			@view.out(target[:record].value || 'NULL') if target[:record]
		when 'NUMEQUALTO'
			@view.out(@database.keys_set_to(value.to_i))
		when 'BEGIN'
			changes = create_new_transaction(@current_transaction)
			commit(changes) if changes
		when 'ROLLBACK'
			if any_open_transactions
				@transaction_stack.pop
				return nil
			end
			@view.out("NO TRANSACTION") unless any_open_transactions 
		else
			@view.out("unrecognized command #{action}")
		end
	end
	
	def create_new_transaction(prior_transaction={})
		this_transaction = TransactionDB.new(prior_transaction)
		@transaction_stack << this_transaction
		@current_transaction = @transaction_stack.last

		listen_for_input
	end
end

		# until @commands.eof?
		# 	current_command = parse_instruction(@commands.readline.chomp)
		# 	action 			    = current_command.first
		# 	key 				    = current_command[1]   || 'key not found'
		# 	value				    = current_command.last || nil
		# 	case action
		# 	when 'SET'
		# 		if any_open_transactions 
		# 			this_transaction.store(key, value.to_i)
		# 		else
		# 		 @database.store(key, value.to_i)
		# 		end
		# 	when 'GET'
		# 		target = this_transaction.retrieve_record(key)
		# 		target = @database.retrieve_record(key) if target[:record] == nil #fall back to database if no transactions manipulated this data				
		# 		@view.out(target[:record].value || 'NULL') if target[:record]
		# 	when 'UNSET'
		# 		this_transaction.wipe(key)
		# 	when 'NUMEQUALTO'
		# 		num_from_db = @database.keys_set_to(value.to_i)
		# 		puts "nums from db: #{num_from_db}"
		# 		num_from_transaction = this_transaction.keys_set_to(value.to_i)
		# 		puts "nums from transaction: #{num_from_transaction}"
		# 		#@view.out(num_from_db + num_from_transaction)
		# 	when 'BEGIN'
		# 		@transaction_stack << true
		# 		changes = create_new_transaction(this_transaction.export)
		# 		return changes if changes #bubble up if there's been a commit further down the call stack
		# 	when 'ROLLBACK'
		# 		if any_open_transactions
		# 			@transaction_stack.pop 
		# 			return nil
		# 		end
		# 	when 'COMMIT'
		# 		@transaction_stack.clear
		# 		return this_transaction
		# 	when 'END'
		# 		exit
		# 	end
		# end




