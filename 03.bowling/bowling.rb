#!/usr/bin/env ruby

# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

# 倒したピンの本数の配列を生成。
frames = shots.each_slice(2).to_a

point = 0
frames.each_with_index do |frame, i|
  point += frame.sum

  # 10フレーム目である場合、またはストライク・スペアでない場合は、次の繰り返しにジャンプする。
  next if i > 8 || frame.sum != 10

  if frame[0] == 10 # ストライクの場合
    point += frames[i + 1].sum
    point += frames[i + 2][0] if frames[i + 1][0] == 10
  else # スペアの場合
    point += frames[i + 1][0]
  end
end
puts point
