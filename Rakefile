require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'ruby-debug'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "ffiruby-filemagic"
    s.summary = %Q{new implementation of the ancient ruby-filemagic gem. Uses FFI to talk to native library}
    s.email = "glongman@overlay.tv"
    s.homepage = "http://github.com/glongman/ffiruby-filemagic"
    s.description = %Q{new implementation of the ancient ruby-filemagic gem. Uses FFI to talk to native library}
    s.authors = ["Geoff Longman"]
    s.add_dependency 'ffi'
    s.executables = ["ffi_file_magic_setup"]
    s.files =  FileList["[A-Z]*", "{lib,bin,test}/**/*"]
    s.post_install_message = "\n\nrun ffi_file_magic_setup to complete the install\n\n\n"
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'ffiruby-filemagic'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs << 'test'
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end
rescue LoadError
end

task :default => :test
