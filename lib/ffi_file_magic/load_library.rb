class FFIFileMagic
  module Native
    module LoadLibrary
      def self.included(base)
        base.class_eval do
          begin
            ffi_lib 'magic'
          rescue LoadError
            puts <<END_LOAD_ERROR
+--------------------------------------------+
| I was unable to load the magic library.    |
|                                            |
| Try running the ffi_file_magic_setup tool  |
+--------------------------------------------+            
END_LOAD_ERROR
            raise
          end
        end
      end
    end
  end 
end
