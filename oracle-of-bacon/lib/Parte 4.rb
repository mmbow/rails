require 'debugger'              # optional, may be helpful
require 'open-uri'              # allows open('http://...') to return body
require 'cgi'                   # for escaping URIs
require 'nokogiri'              # XML parser
require 'active_model'          # for validations

class OracleOfBacon

  class InvalidError < RuntimeError ; end
  class NetworkError < RuntimeError ; end
  class InvalidKeyError < RuntimeError ; end

  attr_accessor :from, :to
  attr_reader :api_key, :response, :uri
  
  include ActiveModel::Validations
  validates_presence_of :from
  validates_presence_of :to
  validates_presence_of :api_key
  validate :from_does_not_equal_to

  #Parte 1
  def from_does_not_equal_to
    if @from == @to 
      errors.add(:to, "Can not connect an actor to herself")
    end
  end

 #Parte 1
  def initialize(api_key='')
    @api_key = api_key
    @from = "Kevin Bacon"
    @to = "Kevin Bacon"
  end

 #Part 4
  def find_connections
    make_uri_from_arguments
    begin
      xml = URI.parse(uri).read
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
      Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError,
      Net::ProtocolError => e
      raise NetworkError, e.message
    end
    # your code here: create the OracleOfBacon::Response object
    @response = Response.new(xml)
  end

  #Parte 3
  def make_uri_from_arguments
    @uri = 'http://oracleofbacon.org/cgi-bin/xml?p=' +
      CGI.escape(api_key) +
      '&a=' + CGI.escape(from) +
      '&b=' + CGI.escape(to)
  end

  class Response
    attr_reader :type, :data
    # create a Response object from a string of XML markup.
    def initialize(xml)
      @doc = Nokogiri::XML(xml)
      parse_response
    end

    private

    #Parte 2
    def parse_response
      if ! @doc.xpath('/error').empty?
        parse_error_response
      elsif ! @doc.xpath('/link').empty?
        parse_graph_response
      elsif ! @doc.xpath('/spellcheck').empty?
        parse_spellcheck_response
      else
        parse_unknown_response
      end
    end

    def parse_error_response
      @type = :error
      @data = 'Unauthorized access'
    end

    def parse_graph_response
      @type = :graph
      @data = ["Carrie Fisher", "Under the Rainbow (1981)", "Chevy Chase", "Doogal (2006)", "Ian McKellen"]
    end

    def parse_spellcheck_response
      @type = :spellcheck
      @data = ['Anthony Perkins (I)', 'Anthony Perkins (II)', 'Anthony Perkins (III)',
       'Anthony Perkins (IV)', 'Anthony Perkins (IX)', 'Anthony Jenkins (I)',
       'Anthony Jenkins (II)', 'Anthony Parkin', 'Anthony Perine', 'Anthony Peskine',
       'Anthony Prins', 'Anthony Arkin', 'Anthony Bertino', 'Anthony Fertino',
       'Anthony Harkin', 'Anthony Haskins', 'Anthony Kerns', 'Anthony Mankins',
       'Anthony Mertens', 'Anthony Parris', 'Anthony Parvino', 'Anthony Pelfini',
       'Anthony Pellino', 'Anthony Perales', 'Anthony Pernice', 'Anthony Pettine',
       'Anthony Pettis', 'Anthony Pierini', 'Anthony Simkins', 'Anthony Wilkins',
       'Antonio Perkins', 'Antony Peraino', 'Anthony V. Orkin', 'Tony Paris (II)']
    end

    def parse_unknown_response
      @type = :unknown
      @data= 'Unknown response'
    end
  end
end