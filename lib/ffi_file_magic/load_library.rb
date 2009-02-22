class FFIFileMagic
  module Native
    module LoadLibrary
      def self.included(base)
        base.class_eval do
          # setup.rb found this library as suitable
          ffi_lib '/opt/local/lib/libmagic.dylib'
        end
      end
    end
  end 
end
