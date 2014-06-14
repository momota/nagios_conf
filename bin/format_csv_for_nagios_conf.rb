#!/usr/local/rbenv/shims/ruby
# -*- coding: utf-8 -*-
require 'csv'
require 'erb'


# format csv file fir nagios conf
class FormatCSVForNagiosConf
  # TODO: yamlなどに外出しする
  W_ERROR_THRESHOLD  = 0
  C_ERROR_THRESHOLD  = 0

  warn_rate  = 0.7
  error_rate = 0.9
  W_TRAFFIC_THRESHOLD_10G  = 10000000000 * warn_rate
  C_TRAFFIC_THRESHOLD_10G  = 10000000000 * error_rate
  W_TRAFFIC_THRESHOLD_1G   = 1000000000  * warn_rate
  C_TRAFFIC_THRESHOLD_1G   = 1000000000  * error_rate
  W_TRAFFIC_THRESHOLD_100M = 100000000   * warn_rate
  C_TRAFFIC_THRESHOLD_100M = 100000000   * error_rate

  def initialize( input_file_path )
    @input_file_path = input_file_path
    @hostname      = File::basename(@input_file_path, '.*')

    @interface = ''
    @ifIndex   = ''
    @w_traffic_threshold = 0
    @c_traffic_threshold = 0
    @w_error_threshold   = W_ERROR_THRESHOLD
    @c_error_threshold   = C_ERROR_THRESHOLD

    @judge_10G  = nil
    @judge_1G   = nil
    @judge_100M = nil
  end

  def format
    cfg_ifInOctets  = ''
    cfg_ifOutOctets = ''
    cfg_ifInErrors  = ''
    cfg_ifOutErrors = ''

    row = CSV.read( @input_file_path )
    row.each { |r|
      @interface = r[0]
      @ifIndex   = r[1]
      case @interface
      when @judge_10G
        @w_traffic_threshold = W_TRAFFIC_THRESHOLD_10G
        @c_traffic_threshold = C_TRAFFIC_THRESHOLD_10G
      when @judge_1G
        @w_traffic_threshold = W_TRAFFIC_THRESHOLD_1G
        @c_traffic_threshold = C_TRAFFIC_THRESHOLD_1G
      when @judge_100M
        @w_traffic_threshold = W_TRAFFIC_THRESHOLD_100M
        @c_traffic_threshold = C_TRAFFIC_THRESHOLD_100M
      else
        next
      end

      cfg_ifInOctets  << ERB.new( File.read('./template/nagios.cfg.ifInOctets.erb') ).result( binding )
      cfg_ifOutOctets << ERB.new( File.read('./template/nagios.cfg.ifOutOctets.erb') ).result( binding )
      cfg_ifInErrors  << ERB.new( File.read('./template/nagios.cfg.ifInErrors.erb') ).result( binding )
      cfg_ifOutErrors << ERB.new( File.read('./template/nagios.cfg.ifOutErrors.erb') ).result( binding )
    }
    return cfg_ifInOctets + cfg_ifOutOctets + cfg_ifInErrors + cfg_ifOutErrors
  end
end


# [JUNIPER] format csv file fir nagios conf
class FormatCSVForNagiosConfJuniper < FormatCSVForNagiosConf
  def initialize( input_file_path )
    super( input_file_path )
    @judge_10G  = Regexp.new('^xe\-')
    @judge_1G   = Regexp.new('^ge\-')
    @judge_100M = Regexp.new('^fe\-')
  end
end


# [CISCO] format csv file fir nagios conf
class FormatCSVForNagiosConfCisco < FormatCSVForNagiosConf
  def initialize( input_file_path )
    super( input_file_path )
    @judge_10G  = Regexp.new('^TenGigabitEthernet')
    @judge_1G   = Regexp.new('^GigabitEthernet')
    @judge_100M = Regexp.new('^FastEthernet')
  end
end
