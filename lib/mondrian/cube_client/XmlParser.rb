require 'nokogiri'
require_relative 'cube'



  class MyParser < Nokogiri::XML::SAX::Document
    bcatalog = false
    bcube = false
    attr_accessor :catalog_name, :data_source_info_str, :list_cubes, :list_catalogs

    def initialize()
      @catalog_name = ""
      @data_source_info_str = ""
      @list_cubes = []
      @list_catalogs = []
    end


    def start_element name, attrs = []
      if name.eql?("Cube")
        bcube = true
        attrs.each { |attribute|
          if attribute.at(0).eql?("name")
            # puts "Cube is #{attribute.at(1)}"
            cube_obj = Mondrian::CubeClient::Cube.new(@data_source_info_str, @catalog_name, attribute.at(1))
            # puts "object is #{cube_obj.inspect}"
            @list_cubes.push(cube_obj)
          end
        }
      end

        if name.eql?("Catalog")
          bcatalog = true
          attrs.each do |attribute|
              @catalog_name = attribute.at(1) if attribute.at(0).eql?("name")
              @data_source_info_str = attribute.at(1) if attribute.at(0).eql?("datasourceinfo")
          end
        end

      end


    def end_element name
      if name.eql?("Catalog")
        temp_list_cubes = @list_cubes.clone
        catalog_obj = Mondrian::CubeClient::Catalog.new(@catalog_name, @data_source_info_str, temp_list_cubes)
        @list_catalogs.push(catalog_obj)
        @catalog_name = ""
        @data_source_info_str = ""
        @list_cubes.clear
      end

      # if name.eql?("Cube")
      #   # puts "-----Cube ends -----"
      #   puts ""
      # end
    end
  end
  






