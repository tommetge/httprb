require 'test/unit'

require File.join(File.dirname(File.dirname(__FILE__)), 'lib/httprb/http_cache.rb')
require File.join(File.dirname(File.dirname(__FILE__)), 'lib/httprb/request.rb')

class TestHTTPCache < Test::Unit::TestCase
  def setup; end
  def teardown; end
  
  def test_connection_caching
    assert_not_nil cache = HTTPrb::HTTPCache.instance
    
    # start things out with a little google...
    assert_not_nil req = HTTPrb::Request.new("http://google.com")
    assert_not_nil res = cache.make_request(req)
    assert res.code =~ /2[0-9].|3[0-9]./
    assert cache.http
    assert cache.http.started?
    
    # play it again, sam... (to test connection caching)
    assert_not_nil res = cache.make_request(req)
    assert res.code =~ /2[0-9].|3[0-9]./
    assert cache.http
    assert cache.http.started?
    
    # try a different host- should transparently stop
    # caching, start over, and make the request
    assert_not_nil req = HTTPrb::Request.new("http://yahoo.com")
    assert_not_nil res = cache.make_request(req)
    assert res.code =~ /2[0-9].|3[0-9]./
    assert cache.http
    assert cache.http.started?
  end
  
  def test_ssl
    assert_not_nil cache = HTTPrb::HTTPCache.instance
    
    assert_not_nil req = HTTPrb::Request.new("https://www.bankofamerica.com")
    assert_not_nil res = cache.make_request(req)
  end
end