# Delegator
#
# inspired by Sinatra, required to play nicely with Sinatra
# (and any other colliding namespace).
#
# It is important to note that all methods defined by HTTPrb
# (get, head, put, post, delete), if defined by the programmer
# or by an included module (ahem, Sinatra), Delegator will
# alias them to a dispatch method, which will do the following:
# 1. print a warning to the user that a collision was
#    deteted and handled.
# 2. tell the user how to call HTTPrb's methods
# 3. call the original method (not HTTPrb's)

require 'irb/completion'

module HTTPrb

module Delegator
  def self.delegate_collision(method)
    ENV['HTTPRB_COLLISION_PREFIX'] ||= 'client_'
    ENV['HTTPRB_IGNORE_COLLISIONS'] ||= 'true'
    eval <<-RUBY, binding, '(__DELEGATE__)', 1
      alias_method #{method.inspect}_original, #{method.inspect}
      
      def #{method}(*args, &b)
        if ENV['HTTPRB_IGNORE_COLLISIONS'] == 'true'
          puts "WARNING: Namespace collision detected"
          puts "HTTPrb::#{method} has been renamed to #{ENV['HTTPRB_COLLISION_PREFIX']}#{method}"
          puts "To disable this message, set HTTPRB_IGNORE_COLLISIONS to false"
        end
        #{method}_original(*args, &b)
      end
      
      def #{ENV['HTTPRB_COLLISION_PREFIX']}#{method}(*args, &b)
        ::HTTPrb.send(#{method.inspect}, *args, &b)
      end
      private #{method.inspect}
    RUBY
  end
  
  def self.collides?(method)
    unless Object.const_defined?(:IRB) and IRB.respond_to?(:conf)
      eval <<-RUBY
        module ::IRB
          def IRB.binding
            #{binding}
          end
          def IRB.workspace; IRB; end
          def IRB.conf; {:MAIN_CONTEXT => IRB}; end
        end
      RUBY
    end
    ::IRB::InputCompletor::CompletionProc.call(method.to_s).include?(method.to_s)
  end
  
  def self.delegate(*methods)
    methods.each do |method_name|
      if self.collides?(method_name)
        self.delegate_collision(method_name)
      else
        eval <<-RUBY, binding, '(__DELEGATE__)', 1
          def #{method_name}(*args, &b)
            ::HTTPrb.send(#{method_name.inspect}, *args, &b)
          end
          private #{method_name.inspect}
        RUBY
      end
    end
  end

  delegate :get, :put, :post, :delete, :head
end

end
