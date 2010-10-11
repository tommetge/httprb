# more magic found here.

# HTTPrb::Request is where most of the actual
# functionality is provided. URI parsing,
# Net::HTTP::Request generation, etc., are all
# handled here.

require 'uri'
require 'cgi'

module HTTPrb
  
class Request
  attr_accessor :uri, :headers, :params, :ssl
  attr_reader :options
  
  # create an HTTPrb::Request object
  #
  # the uri can be formatted however is most
  # convenient to you- if the scheme (http://)
  # is provided, it will be respected. if not
  # provided, the default is http.
  #
  # if https:// is given as the scheme and the
  # necesary openssl library is installed
  # (meaning "require 'net/http'" doesn't fail)
  # then ssl will be used.
  #
  # note that the 'options' parameter is only
  # truly useful (or good) when not passing a
  # block to the DSL. when a block is provided,
  # using the accessor methods for each option
  # (headers, parameters, etc.) is vastly
  # preferred.
  def initialize(uri, options = {})
    if uri.is_a? URI
      @uri = uri
    elsif uri.is_a? String
      @uri = URI.parse(uri)
      if !@uri.scheme
        @uri = URI.parse("http://" + uri)
      end
    else
      raise Exception, "Invalid URL"
    end
    @uri.path = "/" if @uri.path.empty?
    @ssl = true if @uri.scheme == "https"
    
    @options = options
    @options[:type] = 'GET' unless @options[:type]
    
    @parameters = {}
    @headers = {}
  end
  
  # sets up HTTP basic auth- identical to
  # Net::HTTP request objects.
  def basic_auth(user, pass)
    @options[:basic_auth] = true
    @options[:user] = user
    @options[:pass] = pass
  end

  # set a query parameter key/value pair
  def parameter(key, value = nil)
    @parameters[key] = value
  end

  # allows inspection and outside manipulation of
  # query parameters.
  # * returns all parameters
  def parameters
    @parameters
  end
  
  def header(key, value)
    if @headers[key]
      if @headers[key].is_a? Array
        @headers[key] << value
      else
        cur = @headers[key]
        @headers[key] = [cur, value]
      end
    else
      @headers[key] = value
    end
  end
  
  def headers
    @headers
  end
  
  # generates a Net::HTTP request object. for use
  # when the request is passed to Net::HTTP.
  def http_request
    if !@parameters.empty?
      path = "#{@uri.path}?".concat(@parameters.collect {|k,v| "#{k}=#{CGI.escape(v.to_s)}"}.join('&'))
    else
      path = @uri.path
    end
    
    http_req = case @options[:type].upcase
    when 'GET'
      Net::HTTP::Get.new(path)
    when 'POST'
      Net::HTTP::Post.new(path)
    when 'PUT'
      Net::HTTP::Put.new(path)
    when 'HEAD'
      Net::HTTP::Head.new(path)
    when 'DELETE'
      Net::HTTP::Delete.new(path)
    else
      Net::HTTP::Get.new(path)
    end
    if @options[:basic_auth] && @options[:user] && @options[:pass]
      http_req.basic_auth(@options[:user], @options[:pass])
    end
    
    @headers.each do |key, value|
      if value.is_a? Array
        value.each {|v| http_req.add_field(key, v)}
      else
        http_req.add_field(key, value)
      end
    end
    
    return http_req
  end
  
  # yep, you got it. we're messing with your mind
  # here. nothing to see here, move along...
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