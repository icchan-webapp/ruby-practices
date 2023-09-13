#!/usr/bin/env ruby

# frozen_string_literal: true

DISPLAY_COUNT = 20

(1..DISPLAY_COUNT).each do |num|
  result =
    if (num % 15).zero?
      'FizzBuzz'
    elsif (num % 3).zero?
      'Fizz'
    elsif (num % 5).zero?
      'Buzz'
    else
      num.to_s
    end

  puts result
end
