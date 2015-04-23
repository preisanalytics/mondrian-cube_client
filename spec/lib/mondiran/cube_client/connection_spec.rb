require 'spec_helper'

describe Mondrian::CubeClient::Connection do

  describe "initialize" do
    it 'should initialize when the connection is active' do
      allow_any_instance_of(Mondrian::CubeClient::Connection).to receive(:active_connection?).and_return(true)
      connection = Mondrian::CubeClient::Connection.new("http://localhost:8080")
      expect(connection.error).to be_nil
      expect(connection.base_url).to eq("http://localhost:8080")
    end

    it 'should not initialize when the connection is not active' do
      allow_any_instance_of(Mondrian::CubeClient::Connection).to receive(:active_connection?).and_return(false)
      connection = Mondrian::CubeClient::Connection.new("http://localhost:8080")
      expect(connection.error).to be_truthy
      expect(connection.base_url).to be_nil
    end
  end

end