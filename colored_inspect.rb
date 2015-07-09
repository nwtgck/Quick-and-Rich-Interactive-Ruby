# オブジェクトに色付き出力を追加する

require './font'

class Object
	def colored_inspect
		Font.green inspect
	end
end

class Class
	def colored_inspect
		Font.bold Font.blue(inspect)
	end
end

class Array
	def colored_inspect(parents=[])
		new_parents = parents + [self]
		"[" + map{|e|
			if parents.include?(e) || e == self
				"[...]" 
			elsif e.class == Array
				e.colored_inspect(new_parents)
			else
				e.colored_inspect
			end
		}.join(', ') + "]"
	end
end

class Exception
	def colored_inspect
		Font.red inspect
	end
end

class Numeric
	def colored_inspect
		Font.blue inspect
	end
end

class Range
	def colored_inspect
		Font.pink inspect
	end
end

class Symbol
	def colored_inspect
		Font.orange inspect
	end
end

class String
	def colored_inspect
		Font.brown inspect
	end
end

class NilClass
	def colored_inspect
		Font.light_blue inspect
	end
end


class FlaseClass
	def colored_inspect
		Font.light_blue inspect
	end
end

class TrueClass
	def colored_inspect
		Font.light_blue inspect
	end
end

