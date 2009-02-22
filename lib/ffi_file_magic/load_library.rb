module Native
  module LoadLibrary
    def self.included(base)
      base.class_eval do
        # setup.rb didn't need to change this file
        ffi_lib 'magic' 
      end
    end
  end
end  
