require 'test/unit'

$:.unshift File.join(File.dirname(File.dirname(__FILE__)), 'lib')
require 'httprb'

class TestDSL < Test::Unit::TestCase
  def setup
  end
  
  def teardown
  end
  
  def test_get
    assert_not_nil res = get('http://google.com')
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_block
    res = get 'http://google.com' do |req|
      
    end
    assert_not_nil res
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_ssl
    assert_not_nil res = get('https://www.bankofamerica.com/', {:use_ssl => true})
    assert res.code =~ /2[0-9].|3[0-9]./
  end
  
  def test_get_ssl_block
    res = get 'https://www.bankofamerica.com/' do |req|
    end
    assert res.code =~ /2[0-9].|3[0-9]./
  end
end