# 1 Read input from user
# 2	Convert input string to array of strings 
# 3 Determine that the first word is a valid command
# 4   
# 5  
# 6  
class RedisController
	def initialize
		@db = RedisishDB.new
		@transaction_stack = []
	end

	def read_input_from_cli
		command = gets.chomp.split(' ')
		command.each_with_index do |word, index|
			puts "#{index}: #{word}"
		end 
	end

	def route_commands(instruction_set)
		case instruction_set[0]
		when "SET"
		when "GET"
		when "UNSET"
		when "NUMEQUALTO"
		when "BEGIN"
		else
			puts "Command not recognized"
		end
	end

	private
	class Transaction
		
	end

end





