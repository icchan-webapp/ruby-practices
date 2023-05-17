# ライブラリの読み込み。
require 'date'

# 一日と最終日のオブジェクトを作成。
first_date = Date.new(2023, 5, 1)
last_date = Date.new(2023, 5, -1)

# カレンダーの年月と曜日を表示。
puts "5月 2023".center(20)
puts "日 月 火 水 木 金 土"

# 一日の曜日を確認し、それに合わせてインデントを調整。
INITIAL_INDENT = 2
ADDITIONAL_INDENT = 3
add_count = first_date.strftime(format = "%w").to_i

indent = INITIAL_INDENT + ADDITIONAL_INDENT * add_count
print "1".rjust(indent)

# 二日から最終日までをeachメソッドによって、表示。
(2..last_date.day).each do |day|
  date = Date.new(2023, 5, day)
  if date.saturday?
    puts "#{day}".rjust(3)
  elsif date.sunday?
    print "#{day}".rjust(2)
  else
    print "#{day}".rjust(3)
  end
end
