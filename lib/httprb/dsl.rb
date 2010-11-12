# where the magic happens

# this mixin sets up the DSL, wrapping net/http for
# your programming pleasure

# note that each of the following methods accepts a
# block- this is the beauty of the whole thing.

# if you're wondering about the code duplication, read:
#
# http://blog.sidu.in/2007/11/ruby-blocks-gotchas.html
#
# implicit invocation of blocks is just faster. so we
# duplicate code. :(

require 'httprb/request'
require 'httprb/http_cache'

module HTTPrb
  public
  # get request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.get(url, options = {})
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
  def HTTPrb.head(url, options = {})
    options[:type] = 'HEAD'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end
  
  # post request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.post(url, options = {})
    options[:type] = 'POST'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end
  
  # put request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.put(url, options = {})
    options[:type] = 'PUT'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end
  
  # delete request
  # 
  # * options are not generally used; HTTPrb::Request
  #   offers additional methods for option generation/
  #   handling.
  # * accepts a block, handing off the HTTPrb::Request
  #   object to it, if provided.
  def HTTPrb.delete(url, options = {})
    options[:type] = 'DELETE'
    req = Request.new(url, options)
    yield(req) if block_given?
    HTTPrb::HTTPCache.instance.make_request(req)
  end

end
