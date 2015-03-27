require "mondrian/cube_client/version"
require "mondrian/cube_client/connection"

module Mondrian
  module CubeClient
    def self.connection(url)
      Connection.new(url)
    end

   # Your code goes here...
  end
end
