#!/usr/bin/env ruby

DISPLAY_COUNT = 20

(1..DISPLAY_COUNT).each do |num|
  result =
    if num % 15 == 0
      "FizzBuzz"
    elsif num % 3 == 0
      "Fizz"
    elsif num % 5 == 0
      "Buzz"
    else
      num.to_s
    end

  puts result
end
