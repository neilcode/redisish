class Record
	attr_accessor :key, :value
	def initialize(key=nil, value=nil)
		if key
			@key   = key
			@value = value
		else
			raise ArgumentError, 'Record key must have a value'
		end
	end

	def to_h
		{key: @key, value: @value}
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
		else
			return false #needs a fallback search to database. 
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
	
	#binary search for O(log N)
	#returns with either a located record or the best index to insert a new one
	#to maintain ordered data ascending by key
	def locate(searchterm, database)
		#edge case(s)
		return {:record => nil, :index => 0} if database.empty?

		#sorting algorithm takes over once database.length > 1
		if database.length == 1 && searchterm == database.first.key
			return {:record => database.first, :index => 0}
		elsif database.length == 1 && searchterm != database.first.key
			searchterm > database.first.key ? mid = 1 : mid = 0
			return {:record => nil, :index => mid}
		end

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
		return if value == nil
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

class TransactionDB < RedisishDatabase
	attr_reader :storage, :frequency #remove after testing

	def initialize(parent_transaction={})
		@storage = []
		@frequency = []
		if parent_transaction.any?
			import(parent_transaction)
		end
	end

	def import(data)
		if data[:storage] && data[:frequency]
			data[:storage].each do |imported_record|
				@storage << Record.new(imported_record.key, imported_record.value)
			end
			data[:frequency].each do |imported_record|
				@frequency << Record.new(imported_record.key, imported_record.value)
			end
		end
	end

	def export
		{:storage => @storage, :frequency => @frequency}
	end
end
