class RedisishDatabase
	def initialize
		@storage = {}
		@frequencymap = {}
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
end