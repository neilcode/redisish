stack = []
# ARGF.each_line do |line|
# 	# continue if line.nil?
# 	stack << line
# 	break if ARGF.eof?
# end

# WORKS!
# input = ARGF
# p input
# until input.eof?
# 	if input.empty?
# 		puts "no file passed"
# 		if line == "END\n"
# 			puts "i saw an END"
# 			break
# 		end
# 	else

# 		line = input.readline
# 		puts line

# 		if line == "END\n"
# 			puts "i saw an END"
# 			break
# 		end
# 	end
# end


def parse_instructions(stack=nil)
	until stack.first == "END"
		current_task = stack.pop
		case instruction.first
		when "SET"
			puts "setting #{instruction[1]} to #{instruction[2]}"
		when "GET"
			puts "getting the value of #{instruction[1]}"
		when "UNSET"
			puts "setting #{instruction[1]} to NULL"
		when "NUMEQUALS"
			puts "finding the number of entries equal to #{instruction[1]}"
		when "BEGIN"
			
			
		
	end
end



