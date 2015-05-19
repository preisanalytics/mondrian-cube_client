require 'spec_helper'
require 'webmock/rspec'
require 'byebug'
require_relative '../../../../lib/mondrian/cube_client/connection'

describe Mondrian::CubeClient::Connection do


  describe "initialize" do
    it 'should initialize when the connection is active' do
      stub_request(:any, "http://validconnection.com/mondrian/keepalive.html").
          to_return(:body => "abc", :status => 200,
                    :headers => { 'Content-Length' => 3 })
      # allow_any_instance_of(Mondrian::CubeClient::Connection).to receive(:alive?).and_return(true)
      connection = Mondrian::CubeClient::Connection.new("http://validconnection.com")
      expect(connection.alive?).to be true
      expect(connection.error).to be_nil
      expect(connection.base_url).to eq("http://validconnection.com")
    end

    it 'should not initialize when the connection is not active' do
      allow(Net::HTTP).to receive(:get_response).and_raise(Errno::ECONNREFUSED.new())
      connection = Mondrian::CubeClient::Connection.new("www.invalidconnection.com/olap")
      expect(connection.alive?).to be false
      expect(connection.base_url).to eq("www.invalidconnection.com/olap")
      expect(connection.error).to eq("Connection refused")
    end
  end

end