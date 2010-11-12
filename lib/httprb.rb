require 'httprb/dsl'
require 'httprb/delegate'

module HTTPrb
  require 'httprb/version'
  
  begin
    require 'net/https'
  rescue LoadError
    $stderr << "HTTPS not found- disabled"
  end
end

include HTTPrb::Delegator
