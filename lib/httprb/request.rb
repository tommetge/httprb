# more magic found here.

# HTTPrb::Request is where most of the actual
# functionality is provided. URI parsing,
# Net::HTTP::Request generation, etc., are all
# handled here.

require 'uri'
require 'cgi'

module HTTPrb
  
class Request
  attr_accessor :uri, :headers, :parameters, :ssl, :debug,
                :verify_mode
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
    @debug = options[:debug] ? true : false
    
    @parameters = {}
    if @uri.query
      CGI.parse(@uri.query).each do |k,v|
        if v.length == 1
          @parameters[k] = v.first
        else
          @parameters[k] = v
        end
      end
    end
    @headers = {}
  end
  
  # sets up HTTP basic auth- identical to
  # Net::HTTP request objects.
  def basic_auth(user, pass)
    @options[:basic_auth] = true
    @options[:user] = user
    @options[:pass] = pass
  end

  # set or add to a query parameter key/value pair
  # if you wish to set multiple values for a key,
  # provide an array of values as the second argument.
  def parameter(key, value = nil)
    @parameters[key] = value
  end
  
  # set a header key/value pair
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
  
  # generates the query string based on the provided
  # parameter dictionary
  def query_string
    if !@parameters.empty?
      # this is crabby because query strings can have more than
      # one value per key- the key, in that case, is simply
      # repeated with the additional value.
      queries = []
      @parameters.each do |k,v|
        if v.is_a?(Array)
          v.each {|val| queries << "#{k}=#{CGI.escape(val.to_s)}"}
        else
          queries << "#{k}=#{CGI.escape(v.to_s)}"
        end
      end
      return queries.join('&')
    end
    return ""
  end
  
  # generates a Net::HTTP request object. for use
  # when the request is passed to Net::HTTP.
  def http_request
    path = "#{@uri.path}?#{query_string}"
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
  
  def evaluate(&block)
    @self_before_eval = eval "self", block.binding
    r = instance_eval &block
    @self_before_eval = nil # clear our state
    r
  end
  
  # yep, you got it. we're messing with your mind
  # here. nothing to see here, move along...
  def method_missing(method, *args, &block)
    if method == :"ssl?"
      return @ssl
    elsif @options.keys.include?(method)
      return @options[method]
    end
    if @self_before_eval
      @self_before_eval.send method, *args, &block
    else
      super
    end
  end
end

end