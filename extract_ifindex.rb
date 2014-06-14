#!/usr/local/rbenv/shims/ruby
# -*- coding: utf-8 -*-

# extract ifindex from network information 
class ExtractIfIndex
  def initialize( input_file_path )
    @input_file_path = input_file_path
    @ifindex_list   = ''
  end

  def parse( str ); end

  def extract_ifindex
    File::open( @input_file_path ) { |f|
      f.each { |line|
        @ifindex_list << parse( line )
      }
    }
    @ifindex_list
  end
end


# [CISCO] extract ifindex from network information "show snmp mib ifmib ifindex" 
class ExtractIfIndexCisco < ExtractIfIndex
  def parse( str )
    str.split(': Ifindex = ').join(',')
  end

end


# [JUNIPER] extract ifindex from network information "show interfaces | no-more"
class ExtractIfIndexJuniper < ExtractIfIndex
  def parse( str )
    case str
    when /^ *Physical.interface..(.*), Enabled.*/
      return "#{$1},"
    when /^ *Interface.index.*ifIndex: ([0-9]+)/
      return "#{$1}\n"
    when /^ *Logical.interface.(.*)\(.*ifIndex.([0-9]+)/
      return "#{$1},#{$2}\n"
    else
      return ''
    end
  end
end
