require File.dirname(__FILE__) + '/test_helper'

class TestFFIFileMagic < Test::Unit::TestCase
  BASE = File.expand_path(File.dirname(__FILE__)) + "/"
  FILE = BASE + "pyfile"
  LINK = BASE + 'pylink'
  COMPRESSED = BASE + 'pyfile-compressed.gz'
  PERL = BASE + "perl"
  DB = File.expand_path(BASE + '/perl.mgc')
  def test_file
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_NONE)  
    res = fm.file FILE
    assert_equal("a python script text executable", res)
  end
  
  def test_symlink
    File.symlink FILE, LINK
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_NONE)
    res = fm.file LINK
    assert_match(/^symbolic link to `.*pyfile'$/, res)
    fm.close
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_SYMLINK)
    res = fm.file LINK
    assert_equal("a python script text executable", res)
    fm.close
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_SYMLINK | FFIFileMagic::MAGIC_MIME)
    res = fm.file LINK
    assert_equal("text/plain charset=us-ascii", res)
    fm.close
  ensure
    File.unlink LINK
  end
  
  def test_compressed
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_COMPRESS)
    res = fm.file COMPRESSED
    assert_match(/^a python script text executable/, res)
    fm.close
  end

  def test_buffer
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_NONE)
    res = fm.buffer("#!/bin/sh\n")
    fm.close
    assert_equal("POSIX shell script text executable", res)
  end

  def test_check
    fm = FFIFileMagic.new(FFIFileMagic::MAGIC_NONE)
    res = fm.check PERL
    fm.close
    assert_equal(0, res)
  end
  
  def test_compile
    Dir.chdir(File.dirname(__FILE__)) do
      fm = FFIFileMagic.new(FFIFileMagic::MAGIC_NONE)
      res = fm.compile PERL
      fm.close
      assert_equal(0, res)
      File.unlink DB
    end
  end
  
  def file(name)
    File.expand_path(File.dirname(__FILE__)) + "/" + name
  end
end
