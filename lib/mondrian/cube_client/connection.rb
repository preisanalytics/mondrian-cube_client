require 'net/http'
require 'nokogiri'
require_relative "XmlParser"
require 'pathname'
require 'byebug'

CREATE_CUBE_TEMPLATE_PATH = File.expand_path("../../../../data/mondrian/templates/cube_definition_template.xml",
                                             __FILE__)


module Mondrian
  module CubeClient

    # handles the mondrian connection
    # example: Mondrian::CubeClient::Connection.new("http://localhost:8080")
    class Connection

      attr_reader :base_url, :url, :list_objs
      attr_accessor :error

      def alive?
        begin
          @url=URI.parse(@base_url + "/mondrian/keepalive.html")
          Net::HTTP.get_response(@url).code == '200'
        rescue Errno::ECONNREFUSED
          @error = "Connection refused"
          return false
        end
      end

      def initialize(base_url)
          @base_url=base_url
          @url= URI.parse(URI.encode(base_url.strip))
      end

      ################# Gets a cube(s) based on the input #################
      ################# Gets a cube(s) if names of catalog and cube are provided ##################
      ################# Gets a list of cubes if nothing is mentioned #################
      ################# Gets the catalog definition if catalog_name is only provided #################

      def get(catalog_name, cube_name)
        url = ""
        case
          when ((catalog_name.nil? || catalog_name.empty?) && (cube_name.nil? || cube_name.empty?))
            url = "#{base_url}/mondrian/cubecrudapi/cubes"
          when ((catalog_name.nil? || catalog_name.empty?) && !(cube_name.nil? || cube_name.empty?))
            url = "#{base_url}/mondrian/cubecrudapi/cube/#{cube_name}"
          when (!(catalog_name.nil? || catalog_name.empty?) && (cube_name.nil? || cube_name.empty?))
            url = "#{base_url}/mondrian/cubecrudapi/catalog/#{catalog_name}"
          else
            url = "#{base_url}/mondrian/cubecrudapi/cube/#{catalog_name}/#{cube_name}"
        end
        resp = Net::HTTP.get_response(URI.parse(url))
        response_xml = resp.body.strip
        parse_response(response_xml)
        response_xml
      end

      def create(catalog_name,cube_name, connect_string)
        xml = prepare_request(cube_name, connect_string)
        put_path="#{@url.path}/putcube/#{catalog_name}/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = {'Content-Type' => 'text/plain'})
        req.body = xml
        resp = Net::HTTP.new(@url.host, @url.port).start {|http| http.request(req)}
        resp.body.strip
      end

      def update(catalog_name, cube_name, xml)
        put_path="#{@url.path}/putcube/#{catalog_name}/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = { 'Content-Type' => 'text/plain'})
        req.body = xml
        resp = Net::HTTP.new(@url.host, @url.port).start {|http| http.request(req) }
        resp.body.strip
      end

      def delete(catalog_name,cube_name)
        del_path = "#{@url.path}/deletecube/#{catalog_name}/#{cube_name}"
        http = Net::HTTP.new(@url.host, @url.port)
        resp = http.send_request('DELETE', del_path)
        resp.body.strip
      end

      def invalidate_cache_catalog(catalog_name)
        put_path="#{@url.path}/invalidatecache/catalog/#{catalog_name}"
        req = Net::HTTP::Put.new(put_path, initheader = { 'Content-Type' => 'text/plain'})
        resp = Net::HTTP.new(@url.host, @url.port).start {|http| http.request(req) }
        resp.body.strip
      end

      def invalidate_cache_cube(cube_name)
        put_path="#{@url.path}/invalidatecache/cube/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = { 'Content-Type' => 'text/plain'})
        resp = Net::HTTP.new(@url.host, @url.port).start {|http| http.request(req) }
        resp.body.strip
      end

      def parse_response(response_xml)
        myparser = MyParser.new()
        parser = Nokogiri::XML::SAX::Parser.new(myparser)
        parser.parse(response_xml)
        @list_objs = myparser.list_catalogs
        @list_objs.push(response_xml)
      end

      def prepare_request(cube_name, connect_string)
        cubedefinition = File.read(CREATE_CUBE_TEMPLATE_PATH)
        cubedefinition.sub! '@cube_name@', cube_name
        cubedefinition.sub! '@data_source@', connect_string
        cubedefinition
      end
    end
  end
end