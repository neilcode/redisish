class View
	def initialize
		@output = $stdout
	end

	def out(data)
		@output.puts data.to_s + "\n"
	end
end		