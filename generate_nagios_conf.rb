# -*- coding: utf-8 -*-
$LOAD_PATH.push('.')
require 'logger'
require 'bin/extract_ifindex'
require 'bin/format_csv_for_nagios_conf'
require 'bin/file_op'

class GenerateNagiosConf
  def initialize(filepath, maker)
    @input_file_path        = filepath
    @intermediate_file_path = "./output_csv/" + File::basename( @input_file_path )
    @output_file_path       = "./output_nagios/" + File::basename( @input_file_path )
    @maker                  = maker
    @logger                 = Logger.new( STDERR )
  end

  attr_reader :logger

  def control
    exit 1 if !File.exists?( @input_file_path )

    data = nil

    case @maker
    when /juniper/
      logger.debug "[JUNIPER]extraction start"
      data = ExtractIfIndexJuniper.new( @input_file_path ).extract_ifindex
      logger.debug "[JUNIPER]extraction end"
      FileOp.new(@intermediate_file_path, data).output_file
      logger.debug "file output done : #{@intermediate_file_path}"

      logger.debug "[JUNIPER]start formatting"
      data = FormatCSVForNagiosConfJuniper.new( @intermediate_file_path ).format
      logger.debug "[JUNIPER]end formatting"
      FileOp.new(@output_file_path, data).output_file
      logger.debug "file output done : #{@output_file_path}"
    when /cisco/
      logger.debug "[CISCO]extraction start"
      data = ExtractIfIndexCisco.new( @input_file_path ).extract_ifindex
      logger.debug "[CISCO]extraction end"
      FileOp.new(@intermediate_file_path, data).output_file
      logger.debug "file output done : #{@intermediate_file_path}"

      logger.debug "[CISCO]start formatting"
      data = FormatCSVForNagiosConfCisco.new( @intermediate_file_path ).format
      logger.debug "[CISCO]end formatting"
      FileOp.new(@output_file_path, data).output_file
      logger.debug "file output done : #{@output_file_path}"
    else
      logger.error "invalid maker. input 'juniper' or 'cisco'"
      exit 2
    end
  end
end


# ----------------------------------------------------------------------
# MAIN
# ----------------------------------------------------------------------
class Main
  def Main.main
    inputfile = ARGV[0]
    maker     = ARGV[1]
    GenerateNagiosConf.new(inputfile, maker).control
  end
end

if __FILE__ == $0
  Main.main
end
