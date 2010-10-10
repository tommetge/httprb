require 'httprb/dsl'

module HTTPrb
  require 'httprb/version'
  
  begin
    require 'net/https'
  rescue LoadError
    $stderr << "HTTPS not found- disabled"
  end
end