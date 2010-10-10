require 'singleton'
require 'net/http'
require 'net/https'

module HTTPrb

class HTTPCache
  include Singleton
  attr_reader :http
  
  def make_request(req)
    if @http && @http.address == req.uri.host && !@http.started?
      @http.start
    else
      @http = Net::HTTP.new(req.uri.host, req.uri.port)
      @http.use_ssl = req.ssl?
      @http.start
    end
    @http.request(req.http_request)
  end
end

end