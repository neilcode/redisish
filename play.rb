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
20.times do |num|
	database[num] = rand(100)
end
database.uniq!
database.sort!

database.map! {|num| Record.new(num, 'fake value')}

def showdb(database)
	database.each_with_index do |record, index|
		p "#{index}: #{record.key} - #{record.value}\n"
	end
end



def locate(searchterm, data)
	#edge cases
	return 0 if data.empty?


	low  = 0
	high = data.length-1
	mid  = ((low+high)/2)
	while (low < high)
		if searchterm == data[mid].key
			return data[mid]
		elsif searchterm < data[mid].key
			high = mid-1
		elsif searchterm > data[mid].key
			low  = mid+1
		end
		mid = ((low + high)/2)
	end

	puts "final result:"
	puts "low: #{low} - mid: #{mid} - high: #{high}"
	return data[mid] if data[mid].key == searchterm
	return mid+1 		 if searchterm > data[mid].key
	return mid 			 if searchterm < data[mid].key
end


showdb(database)
not_present = rand(100)
while database.count{|record| record.key == not_present} > 0
	not_present = rand(100)
end 
	
p "ATTEMPTING TO FIND BEST SLOT FOR: #{not_present}"
result = locate(not_present, database)

database.insert(result, Record.new(not_present, 'BINGO'))
p database == database.sort_by {|k| k.key}

