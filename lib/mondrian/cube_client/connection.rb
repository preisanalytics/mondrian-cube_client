require 'net/http'
require 'nokogiri'
require_relative "XmlParser"
require 'pathname'

CREATE_CUBE_TEMPLATE_PATH = File.expand_path("../../../../data/mondrian/templates/cube_definition_template.xml", __FILE__)
CREATE_CATALOG_TEMPLATE_PATH = File.expand_path("../../../../data/mondrian/templates/catalog_pgresconnect_definition_template.xml", __FILE__)

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


      ################# Gets a list of cubes if nothing is mentioned #################
      def list_cubes()
        url = "#{base_url}/mondrian/cubecrudapi/cubes"
        resp = Net::HTTP.get_response(URI.parse(url))
        response_xml = resp.body.strip
        parse_response(response_xml)
        response_xml
      end

      ################# Gets a cube(s) based on the input #################
      ################# Gets a cube(s) if names of catalog and cube are provided ##################
      def get_cube(catalog_name, cube_name)
        url = ""
        case
          when ((catalog_name.nil? || catalog_name.empty?) && !(cube_name.nil? || cube_name.empty?))
            url = "#{base_url}/mondrian/cubecrudapi/cube/#{cube_name}"
          else
            url = "#{base_url}/mondrian/cubecrudapi/cube/#{catalog_name}/#{cube_name}"
        end
        resp = Net::HTTP.get_response(URI.parse(url))
        response_xml = resp.body.strip
        parse_response(response_xml)
        response_xml
      end

      ################# Gets the catalog definition if catalog_name is only provided #################
      def get_catalog(catalog_name)
        url = "#{base_url}/mondrian/cubecrudapi/catalog/#{catalog_name}"
        resp = Net::HTTP.get_response(URI.parse(url))
        response_xml = resp.body.strip
        parse_response(response_xml)
        response_xml
      end

      def create_cube(catalog_name, cube_name, cube_definition)
        return "Invalid input parameters" if catalog_name.nil? || cube_name.nil? || cube_definition.nil?
        return "Invalid input parameters" if catalog_name.empty? || cube_name.empty? || cube_definition.empty?
        put_path="#{@url.path}/mondrian/cubecrudapi/putcube/#{catalog_name}/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = {'Content-Type' => 'text/plain'})
        req.body = cube_definition
        resp = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(req) }
        if resp.body.strip.include?("successfully added")
          true
        else
          false
        end
      end

      def update_cube(catalog_name, cube_name, cube_definition)
        return "Invalid input parameters" if catalog_name.nil? || cube_name.nil? || cube_definition.nil?
        return "Invalid input parameters" if catalog_name.empty? || cube_name.empty? || cube_definition.empty?
        put_path="#{@url.path}/mondrian/cubecrudapi/putcube/#{catalog_name}/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = {'Content-Type' => 'text/plain'})
        req.body = cube_definition
        resp = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(req) }
        if resp.body.strip.include?("Cube modified successfully")
          true
        else
          false
        end
      end

      def create_catalog(catalog_name, connect_string)
        xml = prepare_request_catalog(connect_string)
        put_path="#{@url.path}/mondrian/cubecrudapi/catalog/#{catalog_name}"
        req = Net::HTTP::Put.new(put_path, initheader = {'Content-Type' => 'text/plain'})
        req.body = xml
        resp = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(req) }
        if resp.body.strip.include?("Catalog creation was successful")
          true
        else
          false
        end
      end

      def delete_cube(catalog_name, cube_name)
        del_path = "#{@url.path}/mondrian/cubecrudapi/deletecube/#{catalog_name}/#{cube_name}"
        http = Net::HTTP.new(@url.host, @url.port)
        resp = http.send_request('DELETE', del_path)
        resp.body.strip
      end

      def delete_catalog(catalog_name)
        del_path = "#{@url.path}/mondrian/cubecrudapi/catalog/#{catalog_name}"
        http = Net::HTTP.new(@url.host, @url.port)
        resp = http.send_request('DELETE', del_path)
        if resp.body.strip.include?("Catalog successfully deleted")
          true
        else
          false
        end
      end

      def invalidate_cache_catalog(catalog_name)
        put_path="#{@url.path}/mondrian/cubecrudapi/invalidatecache/catalog/#{catalog_name}"
        req = Net::HTTP::Put.new(put_path, initheader = {'Content-Type' => 'text/plain'})
        resp = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(req) }
        resp.body.strip
      end

      def invalidate_cache_cube(cube_name)
        put_path="#{@url.path}/mondrian/cubecrudapi/invalidatecache/cube/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = {'Content-Type' => 'text/plain'})
        resp = Net::HTTP.new(@url.host, @url.port).start { |http| http.request(req) }
        resp.body.strip
      end

      def parse_response(response_xml)
        myparser = MyParser.new()
        parser = Nokogiri::XML::SAX::Parser.new(myparser)
        parser.parse(response_xml)
        @list_objs = myparser.list_catalogs
        @list_objs.push(response_xml)
      end

      
      def prepare_request_catalog(connect_string)
        catalog_definition = File.read(CREATE_CATALOG_TEMPLATE_PATH)
        catalog_definition.sub! '@connectstring@', connect_string
        catalog_definition
      end
    end
  end
end