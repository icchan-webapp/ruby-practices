# frozen_string_literal: true

require 'etc'

class FileStat
  attr_reader :blocks, :file_mode, :nlink, :user_name, :group_name, :size, :mtime, :name

  def initialize(file_name)
    file_stat = File.stat(file_name)

    @blocks = file_stat.blocks
    @file_mode = FileMode.new(file_name).build
    @nlink = file_stat.nlink
    @user_name = Etc.getpwuid(file_stat.uid).name
    @group_name = Etc.getgrgid(file_stat.gid).name
    @size = file_stat.size
    @mtime = file_stat.mtime.strftime('%_m %_d %H:%M')
    @name = file_name
  end

  def build
    { file_mode:, nlink:, user_name:, group_name:, size:, mtime:, name: }
  end
end
