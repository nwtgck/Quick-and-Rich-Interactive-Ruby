require './console.rb'
require './colored_inspect'
require './font'

# エラーしたコマンド
class ErrorCommand
	attr_reader :exception
	attr_reader :command

	def initialize exception, cmd
		@exception = exception 
		@command = cmd
	end

	def colored_inspect
		Font.red inspect
	end

	def inspect
		"#<#{@exception.class.inspect}>"
	end
end

def out_file(a)
	File.open('out.txt', 'a'){|f|
		f.puts a.inspect
	}
end

$commands = [""]
$commands_index = 0
$prompt_str = "[%d]> "
cursor_pos_x = 0

def make_prompt_str
	$prompt_str % $commands.size
end

# メインオブジェクト	
main = Object.new
# メインのバインディングを取得（これでevalしないとローカル変数が失われる）
$main_binding = main.send(:binding)
# --- メインオブジェクトの設定 ---
# out配列を定義
$main_binding.local_variable_set(:out, [nil])
def main.inspect
	"main"
end

# 結果をoutに追加
def add_out(result)
	main_out = $main_binding.local_variable_get(:out)
	main_out.push(result)
	$main_binding.local_variable_set(:out, main_out)

	# 結果をoutNとして追加
	out_file "out#{$commands.size}"
	$main_binding.local_variable_set("out#{$commands.size}", result)
end

# プロンプトを表示
print make_prompt_str
Console.new{|console, ch|

	case ch

	# Ctrl-C
	when Console::KEY_CTRL_C
		puts ""
		exit

	# Ctrl-A
	when Console::KEY_CTRL_A
		console.cursor_left(cursor_pos_x)
		cursor_pos_x = 0

	# Ctrl-K
	when Console::KEY_CTRL_K
		console.clear_right
		$commands[$commands_index].slice!(cursor_pos_x..-1)

	# 上
	when Console::KEY_UP
		out_file "up"
		if $commands_index != 0

			# 入力中のコマンドを表示から消す
			console.cursor_left($commands[$commands_index].size)
			console.clear_right

			# 1つ前のコマンドを表示する
			$commands_index -= 1
			print $commands[$commands_index]
			# カーソルの位置をコマンドの大きさにする
			cursor_pos_x = $commands[$commands_index].size
		end

	# 下
	when Console::KEY_DOWN
		out_file "down"
		if $commands_index != $commands.size-1
			# 入力中のコマンドを表示から消す
			console.cursor_left($commands[$commands_index].size)
			console.clear_right

			# 1つ前のコマンドを表示する
			$commands_index += 1
			print $commands[$commands_index]
			# カーソルの位置をコマンドの大きさにする
			cursor_pos_x = $commands[$commands_index].size
		end

	# 左
	when Console::KEY_LEFT
		out_file "left"
		if cursor_pos_x != 0
			console.cursor_left
			cursor_pos_x -= 1
		end

		out_file cursor_pos_x
	# 右
	when Console::KEY_RIGHT
		out_file "right"
		if cursor_pos_x != $commands[$commands_index].size
			console.cursor_right
			cursor_pos_x += 1
		end

		out_file cursor_pos_x

	# 一文字削除
	when Console::KEY_BACKSPACE
		if cursor_pos_x != 0
			# 一文字消す
			console.cursor_left
			console.clear_right
			$commands[$commands_index].slice!(cursor_pos_x-1)
			rest_command = $commands[$commands_index][cursor_pos_x-1..-1]
			print rest_command
			console.cursor_left(rest_command.size)
			cursor_pos_x -= 1
		else 
			out_file ["削除できません", cursor_pos_x]
		end

	# エンターした時
	when Console::KEY_ENTER
		
		# 改行する
		puts

		# 空白でなければ
		if $commands[$commands_index] != ""
			begin
				# コマンドを評価する
				result = $main_binding.eval($commands[$commands_index])
				# 結果をカラーで表示
				puts "=> " +  result.colored_inspect

				# 結果をoutについか
				add_out(result)

				# # 結果をout配列に挿入
				# main_out = $main_binding.local_variable_get(:out)
				# main_out.push(result)
				# $main_binding.local_variable_set(:out, main_out)

				# # 結果をoutNとして追加
				# out_file "out#{$commands.size}"
				# $main_binding.local_variable_set("out#{$commands.size}", result)
			rescue Exception => exc
				# exitしたなら
				if exc.class == SystemExit
					exit
				end

				# エラーをoutに追加
				add_out(ErrorCommand.new(exc, $commands[$commands_index]))
				# エラーを表示
				puts Font.green_blue(exc.class.to_s+ ": #{exc}")
			end

			# コマンド履歴に入力したコマンドを格納する
			$commands[$commands.size-1] = $commands[$commands_index]

			# 入力中のコマンドを空文字にする
			$commands.push("")
		end

		# コマンド履歴の指す位置を最後にする
		$commands_index = $commands.size-1
		# カーソルの位置を最初にする
		cursor_pos_x = 0

		# プロンプトを表示
		print make_prompt_str

	else
		out_file ["key", ch]

		# 入力中のコマンドを消す
		console.clear_right

		# その他の場合は文字を表示する
		$commands[$commands_index][cursor_pos_x, 0] = ch

		out_file ch.chars
		
		print ch.chars.join
		rest_command = $commands[$commands_index][cursor_pos_x+1..-1]
		print rest_command
		console.cursor_left(rest_command.size)
		# print $commands[$commands_index]

		# カーソルを一つ後ろに進める
		cursor_pos_x += 1
	end
}