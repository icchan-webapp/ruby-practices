# ライブラリの読み込み。
require 'date'
require 'optparse'

# OptionParserオブジェクトoptを作成。
opt = OptionParser.new

# オプションを定義し、オプションに指定された値を変数に代入する。
opt.on('-y VAL') {|v| @year = v.to_i }
opt.on('-m VAL') {|v| @month = v.to_i }
opt.parse!(ARGV)

# オプションが使用されていない場合、デフォルト値を変数に代入する。
today = Date.today
@year = today.year unless @year
@month = today.mon unless @month

# 一日と最終日のオブジェクトを作成。
first_date = Date.new(@year, @month, 1)
last_date = Date.new(@year, @month, -1)

# カレンダーの年月と曜日を表示。
puts "#{@month}月 #{@year}".center(20)
puts "日 月 火 水 木 金 土"

# 一日の曜日を確認し、それに合わせてインデントを調整。
INITIAL_INDENT = 2
ADDITIONAL_INDENT = 3
add_count = first_date.strftime(format = "%w").to_i

indent = INITIAL_INDENT + ADDITIONAL_INDENT * add_count
print "1".rjust(indent)

# 二日から最終日までをeachメソッドによって、表示。
(2..last_date.day).each do |day|
  date = Date.new(@year, @month, day)
  if date.saturday?
    puts "#{day}".rjust(3)
  elsif date.sunday?
    print "#{day}".rjust(2)
  else
    print "#{day}".rjust(3)
  end
end
