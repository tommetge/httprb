# more magic found here.

# HTTPrb::Request is where most of the actual
# functionality is provided. URI parsing,
# Net::HTTP::Request generation, etc., are all
# handled here.

require 'uri'

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
    @options[:headers] = {} unless @options[:headers]
    @options[:params] = {} unless @options[:params]
    @options[:type] = 'GET' unless @options[:type]
  end
  
  # sets up HTTP basic auth- identical to
  # Net::HTTP request objects.
  def basic_auth(user, pass)
    @options[:basic_auth] = true
    @options[:user] = user
    @options[:pass] = pass
  end
  
  # generates a Net::HTTP request object. for use
  # when the request is passed to Net::HTTP.
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