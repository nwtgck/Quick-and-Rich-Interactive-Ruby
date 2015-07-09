require 'io/console'

class Console
	# キーを定義
	KEY_CTRL_A = "\u0001"
	KEY_CTRL_C = "\u0003"
	KEY_CTRL_D = 4.chr
	KEY_CTRL_K = "\v"
	KEY_CTRL_Z = 26.chr
	KEY_ENTER = "\r"
	
	KEY_UP = "\e[A"
	KEY_DOWN = "\e[B"
	KEY_RIGHT = "\e[C"
	KEY_LEFT = "\e[D"
	KEY_BACKSPACE = "\177"

	# コンストラクタ（ブロックを渡すとgetchの無限ループに入る）
	def initialize &blk
		getch(&blk) if block_given?
	end

	# 文字が来るのを待つ
	def getch &blk
		loop {
			input = STDIN.noecho(&:getch)
			if input == "\e"
				input << STDIN.noecho(&:getch)
				input << STDIN.noecho(&:getch)
			end
			blk[self, input]
		}
	end

	def cursor_up(n=1)
		print ("\e[%dA" % n)
	end

	def cursor_down(n=1)
		print ("\e[%dB" % n)
	end

	def cursor_right(n=1)
		print ("\e[%dC" % n) if n != 0
	end

	def cursor_left(n=1)
		print ("\e[%dD" % n) if n != 0
	end

 	# Ctrl-Kした時のように右をすべて消す
	def clear_right
		print "\e[0K"
	end
end
