# 色つけ表示用

class Font
	CLEAR = "\e[0m"
	BOLD = "\033[1m"

	BLUE = "\x1b[38;5;20m"
	RED = "\x1b[38;5;124m"
	PINK = "\x1b[38;5;5m"
	ORANGE = "\x1b[38;5;3m"
	GREEN = "\x1b[38;5;28m"
	BROWN  = "\x1b[38;5;94m"
	LIGHT_BLUE = "\x1b[38;5;6m"
	GREEN_BLUE = "\x1b[38;5;24m"
	

	class << self
		def bold(s)
			BOLD + s + CLEAR
		end

		def blue(s)
			BLUE + s + CLEAR
		end

		def red(s)
			RED + s + CLEAR
		end

		def orange(s)
			ORANGE + s + CLEAR
		end

		def green(s)
			GREEN + s + CLEAR
		end

		def brown(s)
			BROWN + s + CLEAR
		end

		def light_blue(s)
			LIGHT_BLUE + s + CLEAR
		end

		def green_blue s
			GREEN_BLUE + s + CLEAR
		end

		def pink s
			PINK + s + CLEAR
		end
	end
end
