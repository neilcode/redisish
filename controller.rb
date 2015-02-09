class RedisishController

	def initialize(commands=ARGF, database=nil, view=nil)
		@commands = commands
		@database = database
		@view 		= view
		@transaction_stack = []
		@current_transaction = {}
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
		data[:storage].each do |record|
			@database.store(record.key, record.value)
		end
		@transaction_stack.clear
		@current_transaction = {}
	end

	def execute(command)
		action = command.first
		key 	 = command[1]   || 'key not found'
		value	 = command.last || nil
		
		case action
		when 'END'
			exit

		when 'SET'
			if !(value.to_i == 0 && value != '0') #ignore SET command if "SET name" comes in with no value attached
				any_open_transactions ? @current_transaction.store(key, value.to_i) : 	@database.store(key, value.to_i)
			end

		when 'UNSET'
			if any_open_transactions
				if @current_transaction.wipe(key) == false 
					# couldn't find a record in a transaction to unset 
					# fallback to database to look for it. if it exists,
					# retrieve from database, store in transaction with 'DELETE' value
					target = @database.retrieve_record(key)[:record]
					@current_transaction.store(target.key, target.value) if target != nil
					@current_transaction.wipe(target.key) if target != nil
				end
			else
				@database.wipe(key)
			end
	
		when 'GET'
			if any_open_transactions
				target = @current_transaction.retrieve_record(key)
				target = @database.retrieve_record(key) if target[:record] == nil #fallback if no record found in open transactions					
			else
				target = @database.retrieve_record(key)
			end

			if target[:record] && target[:record].value == 'DELETE'
				# edge case: marked for deletion but still inside a uncommitted transaction
				@view.out('NULL')
			elsif target[:record]
				@view.out(target[:record].value || 'NULL') 
			else
				@view.out('NULL')
			end
		
		when 'NUMEQUALTO'
			#WIP
			@view.out("from db: #{@database.keys_set_to(value.to_i)}")
			@view.out("from transaction: #{@current_transaction.keys_set_to(value.to_i)}") if any_open_transactions

		when 'BEGIN'
			if @current_transaction.respond_to?(:export)
				create_new_transaction(@current_transaction.export)
			else
				create_new_transaction
			end
		
		when 'ROLLBACK'
			if any_open_transactions
				@transaction_stack.pop
				@current_transaction = @transaction_stack.last
				return
			end
			@view.out("NO TRANSACTION") unless any_open_transactions 
		
		when 'COMMIT'
			if any_open_transactions
				commit(@current_transaction.export)
				return
			else
				@view.out("NO TRANSACTION")		
			end
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





