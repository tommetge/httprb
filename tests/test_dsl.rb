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
    res = get 'http://google.com' do
      assert type == 'GET'
      assert uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_ssl
    assert_not_nil res = get('https://mozy.com/', {:use_ssl => true})
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_ssl_block
    res = get 'https://mozy.com/' do
      assert type == 'GET'
      assert uri.host = 'mozy.com'
    end
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_head
    assert_not_nil res = head('http://mozy.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_head_block
    res = head 'http://google.com' do
      assert type == 'HEAD'
      assert uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_put
    assert_not_nil res = put('http://mozy.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_put_block
    res = put 'http://google.com' do
      assert type == 'PUT'
      assert uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end

  def test_post
    assert_not_nil res = post('http://mozy.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end

  def test_post_block
    res = post 'http://google.com' do
      assert type == 'POST'
      assert uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end

  def test_delete
    assert_not_nil res = delete('http://mozy.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end

  def test_delete_block
    res = delete 'http://google.com' do |req|
      assert type == 'DELETE'
      assert uri.host = 'mozy.com'
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_params
    res = get 'http://mozy.com' do
      assert parameter "key", "value"
      assert parameter "key2", "value"
      assert parameters.include?("key")
      assert parameters.include?("key2")
      assert http_request.path.include?("key=value")
    end
  end
  
  def test_headers
    res = get 'http://mozy.com' do
      assert header "x-key", "value"
      assert headers["x-key"] == "value"
      assert http_request["x-key"] == "value"
    end
  end
end