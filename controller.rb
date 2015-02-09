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
		puts "COMMITING CHANGES: #{data}"
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
			if !(value.to_i == 0 && value != '0') #ignore SET command if "SET name" comes in with no value attached
				any_open_transactions ? @current_transaction.store(key, value.to_i) : 	@database.store(key, value.to_i)
			end
		when 'UNSET'
			any_open_transactions ? @current_transaction.wipe(key) : @database.wipe(key)
	
		when 'GET'
			if any_open_transactions
				target = @current_transaction.retrieve_record(key)
				target = @database.retrieve_record(key) if target[:record] == nil #fallback if no record found in open transactions					
			else
				target = @database.retrieve_record(key)
			end

			if target[:record]
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
				changes = create_new_transaction(@current_transaction.export)
			elsif @current_transaction
				changes = create_new_transaction(@current_transaction)
			end
			
			commit(changes) if changes
			@transaction_stack.clear
		
		when 'ROLLBACK'
			if any_open_transactions
				@transaction_stack.pop
				@current_transaction = @transaction_stack.last
				return nil
			end
			@view.out("NO TRANSACTION") unless any_open_transactions 
		
		when 'COMMIT'
			if any_open_transactions
				return @current_transaction
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





