require 'httprb/request'
require 'httprb/http_cache'

module HTTPrb
  
  def get(url, options = {})
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end
  
end

include HTTPrb