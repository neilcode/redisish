class RedisishDatabase
	def initialize
		@storage      = []
		@frequencymap = []
	end

	def store(key, value)
		
		value = value.to_i
		@storage.store(key, value)
		if @frequencymap[value]
			@frequencymap[value] += 1
		else
			@frequencymap[value] = 1
		end
	end

	def wipe(key)
		if @storage[key]
			@frequencymap[self.retrieve(key)] -= 1
			@storage[key] = nil
		else
			@storage[key] = nil
		end
	end

	def retrieve(key)
		if @storage[key]
			return @storage[key]
		else
			return "NULL"
		end
	end

	def keys_set_to(value)
		value = value.to_i
		@frequencymap[value]
	end

private

	class Record
		attr_accessor :key, :value
		def initialize(key, value)
			@key   = key
			@value = value
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
		return data[mid] if data[mid].key == searchterm
		
		#no Record found, figure out best index for a new Record
		return mid+1 		 if searchterm > data[mid].key
		return mid 			 if searchterm < data[mid].key
	end

	def change_or_create_new(key, value)
		location = self.locate(key, @database)
		if location.class == Fixnum
			@database.insert(location, Record.new(key, value))
		elsif location.class == Record
			location.value = value

	end

end