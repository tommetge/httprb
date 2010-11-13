# where the magic happens

# this mixin sets up the DSL, wrapping net/http for
# your programming pleasure

# note that each of the following methods accepts a
# block- this is the beauty of the whole thing.

require 'httprb/request'
require 'httprb/http_cache'

module HTTPrb
  public
  def HTTPrb.req(type, url, options = {}, &block)
    options[:type] = type.upcase
    req = Request.new(url, options)
    #yield(req) if block_given?
    req.evaluate(&block) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end

  # get request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.get(url, options = {}, &block)
    HTTPrb.req('GET', url, options, &block)
  end

  # head request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.head(url, options = {}, &block)
    HTTPrb.req('HEAD', url, options, &block)
  end
  
  # post request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.post(url, options = {}, &block)
    HTTPrb.req('POST', url, options, &block)
  end
  
  # put request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.put(url, options = {}, &block)
    HTTPrb.req('PUT', url, options, &block)
  end
  
  # delete request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.delete(url, options = {}, &block)
    HTTPrb.req('DELETE', url, options, &block)
  end

end
