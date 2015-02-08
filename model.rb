class RedisishDatabase
	def initialize
		@storage      = []
		@frequencymap = []
	end

	def search_for_key(searchterm, data)
		# return 0 if data.length == 0 ??

		low  = 0
		high = data.length-1
		mid  = ((high - low)/2)

		while (high-low>1)
			if searchterm == data[mid].key
				#unique record found, so return it
				return data[mid]
			elsif searchterm < data[mid].key
				high = mid
				mid -= ((high-low)/2)
			elsif searchterm > data[mid].key
				low  = mid
				mid += ((high-low)/2)
			end
		end
		return high
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
end