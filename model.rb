class Record
	attr_accessor :key, :value
	def initialize(key, value)
		@key   = key
		@value = value
	end
end

class RedisishDatabase
	def initialize
		@storage   = []
		@frequency = []
	end

	def store(key, new_value)
		target = retrieve_record(key)

		if target[:record]
			adjust_frequency_of(target[:record].value, -1) if target[:record].value != nil
			target[:record].value = new_value
			adjust_frequency_of(target[:record].value, 1)
		else
			create_new(Record.new(key, new_value), target[:index])
			adjust_frequency_of(new_value, 1)
		end
	end

	def wipe(key)
		target = retrieve_record(key)
		if target[:record]
			adjust_frequency_of(target[:record].value, -1)
			target[:record].value = nil 
		end
	end

	def retrieve_record(key)
		locate(key, @storage)
	end

	def keys_set_to(value)
		target = retrieve_frequency_of(value)
		if target[:record]
			target[:record].value
		else
			0
		end
	end

private

	def locate(searchterm, database)
		#edge case(s)
		return {:record => nil, :index => 0} if database.empty?

		low  = 0
		high = database.length-1
		mid  = ((low+high)/2)
		result = {:record=>nil, :index=>nil}
		
		while (low < high)
			if searchterm == database[mid].key
				return {:record => database[mid], :index => mid}
			elsif searchterm < database[mid].key
				high = mid-1
			elsif searchterm > database[mid].key
				low  = mid+1
			end
			mid = ((low + high)/2)
		end
		
		#check the last possible spot
		result = {:record => database[mid], :index => mid} if searchterm == database[mid].key
		
		#otherwise set the best possible index for a new record
		result[:index] = mid+1 if searchterm > database[mid].key
		result[:index] = mid if searchterm < database[mid].key
		
		return result
	end

	def retrieve_frequency_of(value)
		locate(value, @frequency)
	end

	def adjust_frequency_of(value, amount)
		target = retrieve_frequency_of(value)

		if target[:record]
			target[:record].value += amount
		else
			@frequency.insert(target[:index], Record.new(value, 1))
		end
	end

	def create_new(record, index)
		if index <= @storage.length
			@storage.insert(index, record)
			return record # insert returns the whole @storage array, return just the new record instead
		else
			"Error: A new record at this index is out of bounds"
		end
	end

end