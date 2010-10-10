require 'httprb/request'
require 'httprb/http_cache'

module HTTPrb
  
  def get(url, options = {})
    options[:type] = 'GET'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end

  def head(url, options = {})
    options[:type] = 'HEAD'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end

end

include HTTPrb  