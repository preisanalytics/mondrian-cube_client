module Mondrian
  module CubeClient
    class Cube
      attr_writer :connection, :catalog_name, :name
      def initialize(connection, catalog_name, name)
        @connection = connection
        @catalog_name = catalog_name
        @name = name
      end
    end

    class Catalog
      attr_writer :name, :list_cubes, :data_source_info
        def initialize(name, data_source_info, list_cubes)
          @name = name
          @data_source_info = data_source_info
          @list_cubes = list_cubes
        end
      end
    end
  end
