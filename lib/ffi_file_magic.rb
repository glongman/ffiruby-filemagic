require 'rubygems'
require 'ffi'
class FFIFileMagicError < StandardError; end
class FFIFileMagic
  # constants (see magic.h)
  MAGIC_NONE              =0x000000 # No flags 
  MAGIC_DEBUG		          =0x000001 # Turn on debugging 
  MAGIC_SYMLINK		        =0x000002 # Follow symlinks 
  MAGIC_COMPRESS		      =0x000004 # Check inside compressed files 
  MAGIC_DEVICES		        =0x000008 # Look at the contents of devices 
  MAGIC_MIME_TYPE		      =0x000010 # Return only the MIME type 
  MAGIC_CONTINUE		      =0x000020 # Return all matches 
  MAGIC_CHECK		          =0x000040 # Print warnings to stderr 
  MAGIC_PRESERVE_ATIME	  =0x000080 # Restore access time on exit 
  MAGIC_RAW		            =0x000100 # Don't translate unprint chars 
  MAGIC_ERROR		          =0x000200 # Handle ENOENT etc as real errors 
  MAGIC_MIME_ENCODING	    =0x000400 # Return only the MIME encoding 
  MAGIC_MIME              =(FFIFileMagic::MAGIC_MIME_TYPE|FFIFileMagic::MAGIC_MIME_ENCODING) 
  MAGIC_NO_CHECK_COMPRESS	=0x001000 # Don't check for compressed files 
  MAGIC_NO_CHECK_TAR	    =0x002000 # Don't check for tar files 
  MAGIC_NO_CHECK_SOFT	    =0x004000 # Don't check magic entries 
  MAGIC_NO_CHECK_APPTYPE  =0x008000 # Don't check application type 
  MAGIC_NO_CHECK_ELF	    =0x010000 # Don't check for elf details 
  MAGIC_NO_CHECK_ASCII	  =0x020000 # Don't check for ascii files 
  MAGIC_NO_CHECK_TOKENS	  =0x100000 # Don't check ascii/tokens
  
  def initialize(flags)
    @cookie = Native::magic_open(flags)
    raise "out of memory" unless @cookie
    raise  FFIFileMagicError, Native::magic_error(@cookie) if Native::magic_load(@cookie, nil) == -1
  end
  
  def check_cookie
    raise "invalid state: closed" unless @cookie
  end
  
  # returns a textual description of the contents of the filename argument
  def file(filename)
    check_cookie
    raise  FFIFileMagicError, Native::magic_error(@cookie) if (result = Native::magic_file(@cookie, filename)) == nil
    result
  end
  
  # returns a textual description of the contents of the string argument
  def buffer(string)
    check_cookie
    raise  FFIFileMagicError, Native::magic_error(@cookie) if (result = Native::magic_buffer(@cookie, string, string.length)) == nil
    result
  end
 
  # checks the validity of entries in the colon separated database files passed in as filename
  def check(filename)
    check_cookie
    Native::magic_check(@cookie, filename);
  end
  # compile the the colon separated list of database files passed in as filename
  def compile(filename)
    check_cookie
    Native::magic_compile(@cookie, filename);
  end
  
  # closes the magic database and frees any memory allocated.
  # if memory is a concern, use this.
  def close
    check_cookie
    Native::magic_close(@cookie);
    @cookie = nil
  end
  
  module Native
    extend FFI::Library
    
    begin
      ffi_lib 'magic'
    rescue LoadError
      libsuffix = %x(uname -a) =~ /Darwin/ ? '.dylib' : '.so'
      ffi_lib "/opt/local/lib/libmagic" + libsuffix
    end
    
    #magic_t is a pointer (I think)
    #magic_t magic_open(int);
    attach_function :magic_open, [:int], :pointer
    
    #void magic_close(magic_t);
    attach_function :magic_close, [:pointer], :void
    
    # const char *magic_file(magic_t, const char *);
    attach_function :magic_file, [:pointer, :string], :string
    
    # const char *magic_descriptor(magic_t, int);
    attach_function :magic_descriptor, [:pointer, :int], :string
    
    # const char *magic_buffer(magic_t, const void *, size_t);
    attach_function :magic_buffer, [:pointer, :pointer, :int], :string
    
    # const char *magic_error(magic_t);
    attach_function :magic_error, [:pointer], :string
    
    # int magic_setflags(magic_t, int);
    attach_function :magic_setflags, [:pointer, :int], :int

    # int magic_load(magic_t, const char *);
    attach_function :magic_load, [:pointer, :string], :int
    
    # int magic_compile(magic_t, const char *);
    attach_function :magic_compile, [:pointer, :string], :int
    
    # int magic_check(magic_t, const char *);
    attach_function :magic_check, [:pointer, :string], :int
    
    # int magic_errno(magic_t);
    attach_function :magic_errno, [:pointer], :int
    
  end
end

