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
  
  def test_paramaters
    assert_not_nil req = HTTPrb::Request.new('http://localhost', {:type => 'GET'})
    assert req.parameter "key", "value"
    assert req.http_request.path == '/?key=value'
    assert req.parameter "key", ["value", "value2"]
    assert req.http_request.path == '/?key=value&key=value2' || req.http_request.path == '/?key=value2&key=value'
  end
  
  def test_query_string_params
    assert_not_nil req = HTTPrb::Request.new('http://localhost?key=value&key2=value2', {:type => 'GET'})
    assert req.parameters["key"] == "value"
    assert req.parameters["key2"] == "value2"
    assert_not_nil req = HTTPrb::Request.new('http://localhost?key=value&key=value2', {:type => 'GET'})
    assert req.parameters["key"].is_a?(Array)
    assert req.parameters["key"].include?('value') && req.parameters["key"].include?('value2')
  end
  
  def test_headers
    assert_not_nil req = HTTPrb::Request.new('http://localhost', {:type => 'GET'})
    assert(req.header "key", "value")
    assert(req.http_request["key"] == "value")
  end
end