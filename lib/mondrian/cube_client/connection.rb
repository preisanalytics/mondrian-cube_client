require 'net/http'
require 'nokogiri'
require_relative "XmlParser"
#require_relative '../../../data/mondrian/templates/cube_definition_template.xml'
require 'pathname'

CREATE_CUBE_TEMPLATE_PATH = File.expand_path("../../../../data/mondrian/templates/cube_definition_template.xml",
                                             __FILE__)


module Mondrian
  module CubeClient

    # handles the mondrian connection
    # example: Mondrian::CubeClient::Connection.new("http://localhost:8080")
    class Connection

      attr_reader :base_url, :list_objs, :error

      def alive?
        begin
          Net::HTTP.get_response(@url).code == '200'
        rescue Errno::ECONNREFUSED
          return false
        end
      end

      def initialize(base_url)
        @base_url=base_url
        @url=URI.parse(base_url)
      end

      def get(catalog_name, cube_name)
        puts "catalog_name = #{catalog_name} and cube_name = #{cube_name}"
        url = ""
        if ((catalog_name.nil? || catalog_name.empty?) && (cube_name.nil? || cube_name.empty?))
          url = "#{base_url}/cubes"          
        elsif ((catalog_name.nil? || catalog_name.empty?) && !(cube_name.nil? || cube_name.empty?))
          url = "#{base_url}/cube/#{cube_name}"          
        else          
          url = "#{base_url}/cube/#{catalog_name}/#{cube_name}"
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
        puts "the array value for #{@list_objs}"        
      end

      def prepare_request(cube_name, connect_string)
        puts("directory is #{CREATE_CUBE_TEMPLATE_PATH}")
        cubedefinition = File.read(CREATE_CUBE_TEMPLATE_PATH)
        cubedefinition.sub! '@cube_name@', cube_name
        cubedefinition.sub! '@data_source@', connect_string
        cubedefinition
      end
    end
  end
end