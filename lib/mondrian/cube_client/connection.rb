require 'net/http'
require 'nokogiri'
require_relative "XmlParser"

module Mondrian
  module CubeClient
    class Connection

      attr_reader :base_url, :list_objs

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

      def create(catalog_name,cube_name, xml)
        put_path="#{@url.path}/putcube/#{catalog_name}/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = { 'Content-Type' => 'text/plain'})
        req.body = xml
        resp = Net::HTTP.new(@url.host, @url.port).start {|http| http.request(req) }
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

      def parse_response(response_xml)
        puts "The response_xml is #{response_xml}"
        puts ""
        myparser = MyParser.new()
        parser = Nokogiri::XML::SAX::Parser.new(myparser)         
        parser.parse(response_xml)
        puts "Inspecting = #{parser.inspect}"
        @list_objs = myparser.list_catalogs
        @list_objs.push(response_xml)
        puts "the array value for #{@list_objs}"        
      end
    end
  end
end