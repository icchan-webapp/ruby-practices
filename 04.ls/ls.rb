#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

params = ARGV.getopts('a').transform_keys(&:to_sym)

def files(params)
  flags = params[:a] ? File::FNM_DOTMATCH : 0
  Dir.glob('*', flags)
end

files = files(params)
indent = files.map(&:size).max + 1

LINE = 3
row = (files.size.to_f / LINE).ceil

(0..row - 1).each do |i|
  files_for_row = []
  index_of_file = i

  while index_of_file <= files.size - 1
    files_for_row << files[index_of_file].ljust(indent)
    index_of_file += row
  end

  puts files_for_row.join
end
