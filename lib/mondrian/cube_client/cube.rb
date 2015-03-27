module Mondrian
  module CubeClient
    class Cube
      attr_writer :connection
      attr_accessor :catalog_name,:name

      def initialize

      end

      def delete
        @connection.delete(catalog_name,name) if @connection
      end
    end
  end
end