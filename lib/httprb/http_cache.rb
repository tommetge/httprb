# a bit of insanity. a singleton representation
# of a Net::HTTP object. provides connection
# caching when the host is the same. no real
# benefit when changing servers (the underlying
# connection changes when changing servers, no
# way around that).

require 'singleton'
require 'net/http'
require 'net/https'

module HTTPrb

class HTTPCache
  include Singleton
  attr_reader :http
  
  # accepts an HTTPrb::Request object, performs
  # the request, and returns the Net::HTTP result
  def make_request(req)
    if @http && @http.address == req.uri.host && !@http.started?
      @http.start
    else
      @http = Net::HTTP.new(req.uri.host, req.uri.port)
      @http.use_ssl = req.ssl?
      @http.set_debug_output($stderr) if req.debug
      @http.start
    end
    @http.request(req.http_request)
  end
end

end