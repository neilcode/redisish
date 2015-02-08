stack = []

#WORKS
# input = ARGF
# #p input
# until input.eof?
# 	line = input.readline
# 	p line

# 	if line == "END\n" || line == "END"
# 		puts "i saw an END"
# 		break
# 	end
# end

class Record
	attr_accessor :key, :value
	def initialize(key, value)
		@key = key
		@value = value
	end
end

database = []
11.times do |num|
	database[num] = rand(100)
end
database.uniq!
database.sort!

database.map! {|num| Record.new(num, 'fake value')}

def search_for_key(searchterm, data)
	return 0 if data.length == 0

	low  = 0
	high = data.length-1
	mid  = ((high - low)/2)

	while (high-low>1)
		if searchterm == data[mid].key
			return data[mid]
		elsif searchterm < data[mid].key
			high = mid
			mid -= ((high-low)/2)
		elsif searchterm > data[mid].key
			low  = mid
			mid += ((high-low)/2)
		end
	end
	
	# if searchterm < high
	# 	return high-1
	# else
	# 	return high+1
	# end

end



attempt = database.sample

p attempt
result = search_for_key(attempt.key, database)

# database.insert(result, Record.new(12, 'BINGO'))


# p database == database.sort_by {|k| k.key}

