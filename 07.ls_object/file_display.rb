# frozen_string_literal: true

require 'optparse'

class FileDisplay
  NUMBER_OF_COLUMNS = 3

  def initialize
    @options = ARGV.getopts('alr').transform_keys(&:to_sym)
    @file_stats = fetch_file_stats
  end

  def format_file_stat_strings
    @options[:l] ? long_format : short_format
  end

  private

  def fetch_file_stats
    flags = @options[:a] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags)
    sorted_file_names = @options[:r] ? file_names.reverse : file_names
    sorted_file_names.map { |file_name| FileStat.new(file_name) }
  end

  def long_format
    blocks_total = @file_stats.map(&:blocks).sum
    puts "total #{blocks_total}"

    @file_stats.each { |file_stat| puts format_file_stat(file_stat) }
  end

  def format_file_stat(file_stat)
    stat_map = build_stat_map(file_stat)
    max_size_map = build_max_size_map(@file_stats)

    merged_file_stat = [
      '%<file_mode>s',
      "%<nlink>#{max_size_map[:nlink] + 1}s",
      "%<user_name>-#{max_size_map[:user_name] + 1}s",
      "%<group_name>-#{max_size_map[:group_name] + 1}s",
      "%<size>#{max_size_map[:size]}s",
      '%<mtime>2s',
      "%<name>s\n"
    ].join(' ')

    format(merged_file_stat, stat_map)
  end

  def build_stat_map(file_stat)
    {
      file_mode: file_stat.file_mode,
      nlink: file_stat.nlink,
      user_name: file_stat.user.name,
      group_name: file_stat.group.name,
      size: file_stat.size,
      mtime: file_stat.mtime.strftime('%_m %_d %H:%M'),
      name: file_stat.name
    }
  end

  def build_max_size_map(file_stats)
    {
      nlink: file_stats.map { |file_stat| file_stat.nlink.to_s.size }.max,
      user_name: file_stats.map { |file_stat| file_stat.user.name.size }.max,
      group_name: file_stats.map { |file_stat| file_stat.group.name.size }.max,
      size: file_stats.map { |file_stat| file_stat.size.to_s.size }.max,
      name: file_stats.map { |file_stat| file_stat.name.to_s.size }.max
    }
  end

  def short_format
    file_names = @file_stats.map(&:name)
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
