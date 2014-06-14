# -*- coding: utf-8 -*-
$LOAD_PATH.push('.')
require 'logger'
require 'bin/extract_ifindex'
require 'bin/format_csv_for_nagios_conf'
require 'bin/file_op'

class GenerateNagiosConf
  def initialize(filepath, maker)
    @inputFilePath        = filepath
    @intermediateFilePath = "./output_csv/" + File::basename( @inputFilePath )
    @outputFilePath       = "./output_nagios/" + File::basename( @inputFilePath )
    @maker                = maker
    @logger               = Logger.new( STDERR )
  end

  attr_reader :logger

  def control
    exit 1 if !File.exists?( @inputFilePath )

    data = nil

    case @maker
    when /juniper/
      logger.debug "[JUNIPER]extraction start"
      data = ExtractIfIndexJuniper.new( @inputFilePath ).extract_ifindex
      logger.debug "[JUNIPER]extraction end"
      FileOp.new(@intermediateFilePath, data).output_file
      logger.debug "file output done : #{@intermediateFilePath}"

      logger.debug "[JUNIPER]start formatting"
      data = FormatCSVForNagiosConfJuniper.new( @intermediateFilePath ).format
      logger.debug "[JUNIPER]end formatting"
      FileOp.new(@outputFilePath, data).output_file
      logger.debug "file output done : #{@outputFilePath}"
    when /cisco/
      logger.debug "[CISCO]extraction start"
      data = ExtractIfIndexCisco.new( @inputFilePath ).extract_ifindex
      logger.debug "[CISCO]extraction end"
      FileOp.new(@intermediateFilePath, data).output_file
      logger.debug "file output done : #{@intermediateFilePath}"

      logger.debug "[CISCO]start formatting"
      data = FormatCSVForNagiosConfCisco.new( @intermediateFilePath ).format
      logger.debug "[CISCO]end formatting"
      FileOp.new(@outputFilePath, data).output_file
      logger.debug "file output done : #{@outputFilePath}"
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
