

class RedisishDB
	def initialize
		@frequency_map = {}
		@data_storage = {}
		@size = 0
	end

	



end

class Node
	attr_accessor :next
	attr_accessor :value

	def initialize(key, value)
		@key = key.to_s
		@value = value.to_i
		@next = nil
	end
end

class SkipList

end
