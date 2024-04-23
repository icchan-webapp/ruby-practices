# frozen_string_literal: true

class FileMode
  PERMISSION_MAP = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  PERMISSION_SECTION = {
    owner: 0,
    group: 1,
    other: 2
  }.freeze

  def initialize(file_name)
    @file_type = fetch_file_type(file_name)
    permission_numbers = fetch_permission_numbers(File.stat(file_name))
    @permission_symbols = change_numbers_to_symbols(permission_numbers)
  end

  def connect_file_type_and_permission_symbols
    @file_type + @permission_symbols
  end

  private

  def fetch_permission_numbers(file_stat)
    mode = file_stat.mode.to_s(8)
    mode.prepend('0') if mode.size != 6
    mode[2..5]
  end

  def fetch_file_type(file_name)
    file_type = File.ftype(file_name)

    case file_type
    when 'fifo'
      'p'
    when 'file'
      '-'
    else
      file_type.chr
    end
  end

  def change_numbers_to_symbols(permission_numbers)
    permission_numbers[1..3].each_char.map.with_index do |permission_number, index|
      special_permission = permission_numbers[0]
      mode_map = PERMISSION_MAP[permission_number].dup
      before_symbol = mode_map[2]
      after_symbol = fetch_after_symbol(index, special_permission, before_symbol)

      if !after_symbol.nil?
        mode_map[2] = after_symbol
        next mode_map
      end

      PERMISSION_MAP[permission_number]
    end.join
  end

  def fetch_after_symbol(index, special_permission, before_symbol)
    case index
    when PERMISSION_SECTION[:owner]
      if special_permission == '4'
        before_symbol == 'x' ? 's' : 'S'
      end
    when PERMISSION_SECTION[:group]
      if special_permission == '2'
        before_symbol == 'x' ? 's' : 'S'
      end
    when PERMISSION_SECTION[:other]
      if special_permission == '1'
        before_symbol == 'x' ? 't' : 'T'
      end
    end
  end
end
