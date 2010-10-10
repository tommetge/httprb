require 'uri'

module HTTPrb
  
class Request
  attr_accessor :uri, :headers, :params, :ssl
  attr_reader :options
  
  def initialize(uri, options = {})
    if uri.is_a? URI
      @uri = uri
    elsif uri.is_a? String
      @uri = URI.parse(uri)
    else
      raise Exception, "Invalid URL"
    end
    @uri.path = "/" if @uri.path.empty?
    @ssl = true if @uri.scheme == "https"
    
    @options = options
    @options[:headers] = {} unless @options[:headers]
    @options[:params] = {} unless @options[:params]
    @options[:type] = 'GET' unless @options[:type]
  end
  
  def basic_auth(user, pass)
    @options[:basic_auth] = true
    @options[:user] = user
    @options[:pass] = pass
  end
  
  def http_request
    http_req = case @options[:type].upcase
    when 'GET'
      Net::HTTP::Get.new(@uri.path)
    when 'POST'
      Net::HTTP::Post.new(@uri.path)
    when 'PUT'
      Net::HTTP::Put.new(@uri.path)
    when 'HEAD'
      Net::HTTP::Head.new(@uri.path)
    when 'DELETE'
      Net::HTTP::Delete.new(@uri.path)
    else
      Net::HTTP::Get.new(@uri.path)
    end
    if @options[:basic_auth] && @options[:user] && @options[:pass]
      http_req.basic_auth(@options[:user], @options[:pass])
    end
    
    return http_req
  end
  
  def method_missing(method)
    if method == :"ssl?"
      return @ssl
    elsif @options.keys.include?(method)
      return @options[method]
    end
    super
  end
end

end