# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{ffiruby-filemagic}
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Geoff Longman"]
  s.date = %q{2009-02-23}
  s.default_executable = %q{ffi_file_magic_setup}
  s.description = %q{new implementation of the ancient ruby-filemagic gem. Uses FFI to talk to native library}
  s.email = %q{glongman@overlay.tv}
  s.executables = ["ffi_file_magic_setup"]
  s.files = ["LICENSE", "Rakefile", "README", "VERSION.yml", "lib/ffi_file_magic", "lib/ffi_file_magic/ffi_file_magic.rb", "lib/ffi_file_magic/load_library.rb", "lib/ffi_file_magic.rb", "bin/ffi_file_magic_setup", "test/ffiruby_filemagic_test.rb", "test/leaktest.rb", "test/perl", "test/pyfile", "test/pyfile-compressed.gz", "test/test_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/glongman/ffiruby-filemagic}
  s.post_install_message = %q{

run ffi_file_magic_setup to complete the install


}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{new implementation of the ancient ruby-filemagic gem. Uses FFI to talk to native library}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, [">= 0"])
    else
      s.add_dependency(%q<ffi>, [">= 0"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0"])
  end
end
