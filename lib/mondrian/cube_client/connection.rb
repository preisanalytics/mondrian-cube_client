require 'net/http'

module Mondrian
  module CubeClient
    class Connection

      attr_reader :base_url

      def initialize(base_url)
        @base_url=base_url
        @url=URI.parse(base_url)
      end

      def get(catalog_name,cube_name)
        url="#{base_url}/cube/#{catalog_name}/#{cube_name}"
        xml=Net::HTTP.get_response(URI.parse(url))
        cube=parse_response(xml)
        cube.connection=self
        cube
      end

      def create(catalog_name,cube_name,xml)
        put_path="#{@url.path}/putcube/#{catalog_name}/#{cube_name}"
        req = Net::HTTP::Put.new(put_path, initheader = { 'Content-Type' => 'text/plain'})
        req.body = xml
        Net::HTTP.new(@url.host, @url.port).start {|http| http.request(req) }
      end

      def list(catalog_name)

      end


      def update

      end

      def delete(catalog_name,cube_name)

      end
    end

  end
end

# begin
#
#   cube_name = 'Warehouse1'
#   catalog_name = 'FoodMart'
# #get all the cubes
# #url = 'http://localhost:8080/mondrian/cubecrudapi/cubes'
#
# #get a cube based on a catalog
#
# =begin
#
# url = 'http://localhost:8080/mondrian/cubecrudapi/cube/' + catalog_name + '/' + cube_name
#
#
# #get a catalog definition
#
# 	url = 'http://localhost:8080/mondrian/cubecrudapi/catalog/' + catalog_name
#
#
#
# =end
# #put a catalog/cube definition
#
# # Read the input xml from a file
#
# #url = 'http://localhost:8080/mondrian/cubecrudapi/putcube/' + catalog_name + '/' + cube_name
#
#   url = '/mondrian/cubecrudapi/putcube/' + catalog_name + '/' + cube_name
#
#
#   port = 8080
#   host = "localhost"
#   path = '/mondrian/cubecrudapi/putcube/' + catalog_name + '/' + cube_name
#
#
# #url = '/mondrian/cubecrudapi/deletecube/' + catalog_name + '/' + cube_name
#
#   file = File.new("/home/shazra/work/Docs/Project mondrian/mondrianxmlas/inputPUT.xml", "r")
#   input_xml = ""
#   while (line = file.gets)
#     input_xml = input_xml + line
#     puts line
#   end
#   file.close
#   puts "The url used is=" + url
#
#   req = Net::HTTP::Put.new(path, initheader = {'Content-Type' => 'text/plain'})
#   req.body = input_xml
#   response = Net::HTTP.new(host, port).start { |http| http.request(req) }
#   puts response.body
#
#   input_xml = input_xml.gsub! '"', '\"'
#   puts "----Input xml-----"
#   puts input_xml
#
#
#   puts "------------The response xml from Mondrian--------------------"
# #http = Net::HTTP.new('localhost', 8080)
#
# #resp = http.send_request('PUT', url, input_xml)
#
#   request = Net::HTTP::Put.new(url)
#
# #resp = http.send_request('DELETE', url )
#
# #resp = Net::HTTP.get_response(URI.parse(url))
#   case resp
#     when Net::HTTPSuccess then
#       puts resp.body
#     when Net::HTTPRedirection then
#       location = resp['location']
#       warn "redirected to #{location}"
#     else
#       puts resp.value
#   end
#
# rescue Exception => e
#   puts e.message
#   puts e.backtrace.inspect
# end
#
# puts "----The End!!----"