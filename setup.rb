#!/usr/bin/env ruby

require "rubygems"
require "ffi"

module FFIFileMagic
  module Checker
    def self.check_lib(dylib)
      puts "checking for needed methods in #{dylib.name}"
      result = true
      [:magic_open,   :magic_close,   :magic_file,
       :magic_buffer, :magic_error,   :magic_setflags,
       :magic_load,   :magic_compile, :magic_check,
       :magic_errno].each do |method|
         result &= begin
           print "\tmethod exists? #{method} ... "
           if dylib.find_symbol(method.to_s) 
             puts "yes"; true
           else
             puts "no"; false
           end
         end
      end
      if result
        puts "\t#{dylib.name} suitable? ... #{result ? 'yes' : 'no'}"; return dylib
      end
    end
  end
end
#sorry, no windows
if RUBY_PLATFORM =~ /mswin/
  raise <<END_MSWIN
\nInstall Failed
+--------------------------------------------------------------------+
| This gem is for use only on Linux, BSD, OS X, and similar systems. |
+--------------------------------------------------------------------+
END_MSWIN
end

# no fuss, no muss?
default_dylib = nil
begin
  default_dylib = FFI::DynamicLibrary.open('magic', FFI::DynamicLibrary::RTLD_LAZY | FFI::DynamicLibrary::RTLD_LOCAL)
rescue LoadError; end

dylib = FFIFileMagic::Checker.check_lib(default_dylib) if default_dylib

unless dylib
  #check some usual suspects
  paths = %w{ /lib/ /usr/lib/ /usr/local/lib/ /opt/local/lib/}
  libname = FFI.map_library_name('magic')
  found_path = nil
  paths.uniq.each do |path|
     full_path = path + libname
  	 if File.exist? full_path
  	   begin
  	     dylib = FFI::DynamicLibrary.open(full_path, FFI::DynamicLibrary::RTLD_LAZY | FFI::DynamicLibrary::RTLD_LOCAL)
    	   break if FFIFileMagic::Checker.check_lib(dylib)
	     rescue LoadError; end
     end
  end
end

unless dylib
  raise <<END_FAIL
\nInstall Failed
+----------------------------------------------------------------------------+
| Could not find a suitable magic library.                                   |
|                                                                            |
| OSX - use macports               http://www.macports.org/                  |
|     > port install file                                                    |
|                                                                            |
| Others - build file from source - ftp://ftp.astron.com/pub/file/           |
+----------------------------------------------------------------------------+
END_FAIL
end

template =<<END_TEMPLATE
module Native
  module LoadLibrary
    def self.included(base)
      base.class_eval do
        # setup.rb found this library as suitable
        ffi_lib '#{dylib.name}'
      end
    end
  end
end  
END_TEMPLATE

if dylib != default_dylib
  print "writing path #{dylib.name} into lib/ffi_file_magic/load_library.rb ...."
  load_library = File.expand_path(File.dirname(__FILE__) + '/lib/ffi_file_magic/load_library.rb')
  File.open(load_library, 'w') do |file|
    file.write template
  end
  puts "success"
end

puts "\n Finished."










