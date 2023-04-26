#!/usr/bin/env ruby

NUMBER_OF_DISPLAY_TIMES = 20

for num in 1 .. NUMBER_OF_DISPLAY_TIMES do
  result =
    if num % 3 == 0 && num % 5 == 0
      "FizzBuzz"
    elsif num % 3 == 0
      "Fizz"
    elsif num % 5 == 0
      "Buzz"
    else
      num
    end

  puts result
end
