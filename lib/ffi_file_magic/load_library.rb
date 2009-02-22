module Native
  module LoadLibrary
    def self.included(base)
      base.class_eval do
        # setup.rb found this library as suitable
        ffi_lib 'magic'
      end
    end
  end
end  
