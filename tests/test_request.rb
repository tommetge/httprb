require 'test/unit'

require File.join(File.dirname(File.dirname(__FILE__)), 'lib/httprb/request.rb')
require 'net/http'

class TestRequest < Test::Unit::TestCase
  def setup; end
  def teardown; end
  
  def test_request_types
    assert_not_nil req = HTTPrb::Request.new('http://google.com', {:type => 'POST'})
    assert req.http_request.is_a? Net::HTTP::Post
    assert_not_nil req = HTTPrb::Request.new('http://google.com', {:type => 'PUT'})
    assert req.http_request.is_a? Net::HTTP::Put
    assert_not_nil req = HTTPrb::Request.new('http://google.com', {:type => 'HEAD'})
    assert req.http_request.is_a? Net::HTTP::Head
    assert_not_nil req = HTTPrb::Request.new('http://google.com', {:type => 'DELETE'})
    assert req.http_request.is_a? Net::HTTP::Delete
    assert_not_nil req = HTTPrb::Request.new('http://google.com', {:type => 'GET'})
    assert req.http_request.is_a? Net::HTTP::Get
    assert_not_nil req = HTTPrb::Request.new('http://google.com')
    assert req.http_request.is_a? Net::HTTP::Get
  end
  
  def test_ssl
    assert_not_nil req = HTTPrb::Request.new("https://www.bankofamerica.com")
    assert req.ssl?
    assert req.ssl
  end
end