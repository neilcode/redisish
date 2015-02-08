class View
	def initialize
		@output = $stdout
	end

	def out(data)
		@output.print data.to_s + "\n"
	end
end		