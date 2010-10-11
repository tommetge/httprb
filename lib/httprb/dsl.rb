# where the magic happens

# this mixin sets up the DSL, wrapping net/http for
# your programming pleasure

# note that each of the following methods accepts a
# block- this is the beauty of the whole thing.

require 'httprb/request'
require 'httprb/http_cache'

module HTTPrb
  
  # get request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def get(url, options = {})
    options[:type] = 'GET'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end

  # head request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def head(url, options = {})
    options[:type] = 'HEAD'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end

end

include HTTPrb  