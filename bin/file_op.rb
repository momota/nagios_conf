#!/usr/local/rbenv/shims/ruby
# -*- coding: utf-8 -*-

class FileOp
  def initialize(filename, data)
    @filepath  = filename
    @data      = data
  end

  def output_file
    dir = File::dirname( @filepath )
    Dir::mkdir( dir ) if !FileTest::directory?( dir )

    File.open(@filepath, "w") { |f|
      f.write( @data )
    }
  end
end

