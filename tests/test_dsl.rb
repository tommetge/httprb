require 'test/unit'

$:.unshift File.join(File.dirname(File.dirname(__FILE__)), 'lib')
require 'httprb'

class TestDSL < Test::Unit::TestCase
  def setup
  end
  
  def teardown
  end
  
  def test_get_urls
    assert_not_nil res = get('http://mozy.com')
    assert_not_nil res = get('mozy.com')
  end
  
  def test_get
    assert_not_nil res = get('http://mozy.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_block
    res = get 'http://google.com' do |req|
      assert_not_nil req
      assert req.options[:type] == 'GET'
      assert req.uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_ssl
    assert_not_nil res = get('https://mozy.com/', {:use_ssl => true})
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_ssl_block
    res = get 'https://mozy.com/' do |req|
      assert_not_nil req
      assert req.options[:type] == 'GET'
      assert req.uri.host = 'mozy.com'
    end
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_head
    assert_not_nil res = head('http://mozy.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_head_block
    res = head 'http://google.com' do |req|
      assert_not_nil req
      assert req.options[:type] == 'HEAD'
      assert req.uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_params
    res = get 'http://mozy.com' do |req|
      assert req.parameter "key", "value"
      assert req.parameter "key2", "value"
      assert req.parameters.include?("key")
      assert req.parameters.include?("key2")
    end
  end
  
  def test_headers
    res = get 'http://mozy.com' do |req|
      assert req.header "x-key", "value"
      assert req.headers["x-key"] == "value"
      assert req.http_request["x-key"] == "value"
    end
  end
end