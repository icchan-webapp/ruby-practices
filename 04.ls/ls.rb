#!/usr/bin/env ruby

# frozen_string_literal: true

files = Dir.glob('*')
indent = files.map(&:size).max + 1

LINE = 3
row = (files.size.to_f / LINE).ceil

(0..row - 1).each do |i|
  files_for_row = []
  indent_of_file = i

  while indent_of_file <= files.size - 1
    files_for_row << files[indent_of_file].ljust(indent)
    indent_of_file += row
  end

  puts files_for_row.join
end
