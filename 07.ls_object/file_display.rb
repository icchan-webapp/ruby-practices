# frozen_string_literal: true

require 'optparse'

class FileDisplay
  attr_reader :options, :files_stat

  NUMBER_OF_COLUMNS = 3

  def initialize
    @options = ARGV.getopts('alr').transform_keys(&:to_sym)
    @files_stat = fetch_files_stat
  end

  def format
    options[:l] ? long_format : short_format
  end

  private

  def fetch_files_stat
    flags = options[:a] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags)
    options[:r] ? file_names.reverse! : file_names
    file_names.map { |file_name| FileStat.new(file_name) }
  end

  def long_format
    blocks_total = files_stat.map(&:blocks).sum
    puts "total #{blocks_total}"

    files_stat.each { |file_stat| puts format_file_stat(file_stat) }
  end

  def format_file_stat(file_stat)
    file_stat.build.map.with_index(1) do |stat, display_order_from_left|
      stat_key = stat[0]
      stat_value = stat[1]
      margin = generate_margin(display_order_from_left)
      max_chars = calc_max_chars(files_stat, stat_key)
      format_stat_value(display_order_from_left, stat_value, margin, max_chars)
    end.join
  end

  def generate_margin(display_order_from_left)
    case display_order_from_left
    when 1
      0
    when 2, 3, 7
      1
    else
      2
    end
  end

  def calc_max_chars(files_stat, stat_key)
    files_stat.map { |file_stat| file_stat.build[stat_key].to_s.size }.max
  end

  def format_stat_value(display_order_from_left, stat_value, margin, max_chars)
    return stat_value.to_s.rjust(max_chars + margin) if display_order_from_left != 7

    stat_value.ljust(max_chars).rjust(max_chars + margin)
  end

  def short_format
    file_names = files_stat.map(&:name)
    width = file_names.map(&:size).max + 1
    number_of_rows = (file_names.size.to_f / NUMBER_OF_COLUMNS).ceil
    show_formatted_file_names(file_names, width, number_of_rows)
  end

  def show_formatted_file_names(file_names, width, number_of_rows)
    (0..number_of_rows - 1).each do |i|
      files_for_row = []
      file_name_index = i

      while file_name_index <= file_names.size - 1
        files_for_row << file_names[file_name_index].ljust(width)
        file_name_index += number_of_rows
      end

      puts files_for_row.join
    end
  end
end
