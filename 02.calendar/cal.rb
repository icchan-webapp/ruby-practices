#!/usr/bin/env ruby

# ライブラリの読み込み。
require 'date'
require 'optparse'

# OptionParserオブジェクトoptを作成。
opt = OptionParser.new

# 現在の年月を変数に代入。
today = Date.today
year = today.year
month = today.mon

# 年月を指定するオプションを定義。
opt.on('-y VAL') {|v| year = v.to_i }
opt.on('-m VAL') {|v| month = v.to_i }
opt.parse!(ARGV)

# 一日と最終日のオブジェクトを作成。
first_date = Date.new(year, month, 1)
last_date = Date.new(year, month, -1)

# カレンダーの年月と曜日を表示。
puts "#{month}月 #{year}".center(20)
puts "日 月 火 水 木 金 土"

# 一日の曜日に合わせて、一日のインデントを算出。
ADDITIONAL_INDENT = 3
add_count = first_date.strftime(format = "%w").to_i
indent = ADDITIONAL_INDENT * add_count

# 一日のインデントを反映。
print "".rjust(indent)

# 一日から最終日までをRangeクラスとeachメソッドによって、取得。
(first_date..last_date).each do |date|
  # 日にちを文字列にし、インデントを調整。
  day = date.day.to_s.rjust(2)

  # 今日の場合、文字色と背景色を反転。
  day = "\e[7m#{day}\e[0m" if date == today

  # 日にちを出力。
  print "#{day}"

  # 曜日によって、改行とスペースを変更。
  if date.saturday?
    puts
  else
    print "".rjust(1)
  end
end

# カレンダーの最後の行とプロンプトの間に一行空きを作成。
puts last_date.saturday? ? "\n" : "\n "
