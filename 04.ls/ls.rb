#!/usr/bin/env ruby

# frozen_string_literal: true
# shareable_constant_value: literal

require 'optparse'
require 'etc'

params = ARGV.getopts('l').transform_keys(&:to_sym)

files = Dir.glob('*')

if params[:l]
  def mode(file_status)
    mode = file_status.mode.to_s(8)
    mode.prepend('0') if mode.size != 6
    mode
  end

  PERMISSION_MARKS = { r: 4, w: 2, x: 1 }

  def change_numbers_to_chars(index, number, special_permission)
    PERMISSION_MARKS.map do |permission_mark, value|
      if index == 2 && permission_mark == :x && special_permission != '0'
        change_x_to_special_permission(number, special_permission)
      elsif number >= value
        number -= value
        permission_mark
      else
        '-'
      end
    end
  end

  SPECIAL_PERMISSIONS = { t: '1', sgid: '2', suid: '4' }

  def change_x_to_special_permission(number, special_permission)
    special_permission_key = SPECIAL_PERMISSIONS.key(special_permission)
    number < 1 ? special_permission_key.upcase[0] : special_permission_key[0]
  end

  def file_type_chr(file)
    file_type = File.ftype(file)

    case file_type
    when 'fifo'
      'p'
    when 'file'
      '-'
    else
      file_type.chr
    end
  end

  def max_chars(files_with_details, index)
    files_with_details.transpose[index].map { |file_with_detail| file_with_detail.to_s.strip.size }.max
  end

  blocks_total = 0
  
  files_with_details =
    files.map do |file|
      file_status = File.stat(file)
      mode = mode(file_status)
      permission_numbers = mode[3, 3]
      special_permission = mode[2]

      permissions =
        permission_numbers.each_char.map.with_index do |permission_number, index|
          number = permission_number.to_i
          change_numbers_to_chars(index, number, special_permission)
        end

      nlink = file_status.nlink
      uid = Etc.getpwuid(file_status.uid).name
      gid = Etc.getgrgid(file_status.gid).name
      size = file_status.size
      mtime = file_status.mtime.strftime('%-m %-d %H:%M')
      blocks_total += file_status.blocks

      [permissions.unshift(file_type_chr(file)).join, nlink, uid, gid, size, mtime, file]
    end

  puts "total #{blocks_total}"

  files_with_details.each do |file_with_details|
    file_with_details.each_with_index do |file_with_detail, index|
      max_chars = max_chars(files_with_details, index)
      margin =
        if index.zero?
          0
        elsif [1, 2, 6].include?(index)
          1
        else
          2
        end

      file_with_details[index] =
        if index != 6
          file_with_detail.to_s.rjust(max_chars + margin)
        else
          file_with_detail.to_s.ljust(max_chars).rjust(max_chars + margin)
        end
    end

    puts file_with_details.join
  end
else
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
end
