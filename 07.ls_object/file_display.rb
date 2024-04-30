# frozen_string_literal: true

require 'optparse'

class FileDisplay
  COLUMN_COUNT = 3

  def initialize
    @options = ARGV.getopts('alr').transform_keys(&:to_sym)
    @file_details = fetch_file_details
  end

  def show_files
    @options[:l] ? long_format : short_format
  end

  private

  def fetch_file_details
    flags = @options[:a] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags)
    sorted_file_names = @options[:r] ? file_names.reverse : file_names
    sorted_file_names.map { |file_name| FileDetail.new(file_name) }
  end

  def long_format
    blocks_total = @file_details.map(&:blocks).sum
    puts "total #{blocks_total}"

    @file_details.each { |file_detail| puts format_file_detail(file_detail) }
  end

  def format_file_detail(file_detail)
    max_sizes = build_max_sizes(@file_details)

    [
      file_detail.fetch_file_mode_strings,
      file_detail.nlink.to_s.rjust(max_sizes[:nlink] + 1),
      file_detail.user_name.ljust(max_sizes[:user_name] + 1),
      file_detail.group_name.ljust(max_sizes[:group_name] + 1),
      file_detail.size.to_s.rjust(max_sizes[:size]),
      file_detail.mtime.strftime('%_m %_d %H:%M'),
      file_detail.name
    ].join(' ')
  end

  def build_max_sizes(file_details)
    {
      nlink: file_details.map { |file_detail| file_detail.nlink.to_s.size }.max,
      user_name: file_details.map { |file_detail| file_detail.user.name.size }.max,
      group_name: file_details.map { |file_detail| file_detail.group.name.size }.max,
      size: file_details.map { |file_detail| file_detail.size.to_s.size }.max,
      name: file_details.map { |file_detail| file_detail.name.to_s.size }.max
    }
  end

  def short_format
    file_names = @file_details.map(&:name)
    width = file_names.map(&:size).max + 1
    row_count = (file_names.size.to_f / COLUMN_COUNT).ceil
    format_file_names(file_names, width, row_count)
  end

  def format_file_names(file_names, width, row_count)
    (0..row_count - 1).each do |i|
      files_for_row = []
      file_name_index = i

      while file_name_index <= file_names.size - 1
        files_for_row << file_names[file_name_index].ljust(width)
        file_name_index += row_count
      end

      puts files_for_row.join
    end
  end
end
