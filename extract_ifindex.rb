#!/usr/local/rbenv/shims/ruby
# -*- coding: utf-8 -*-

# extract ifindex from network information 
class ExtractIfIndex
  def initialize( inputFilePath )
    @inputFilePath = inputFilePath
    @ifindexList   = ''
  end

  def parse( str ); end

  def extract_ifindex
    File::open( @inputFilePath ) { |f|
      f.each { |line|
        @ifindexList << parse( line )
      }
    }
    @ifindexList
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