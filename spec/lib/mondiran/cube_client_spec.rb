require 'spec_helper'

RSpec.describe Mondrian::CubeClient do

  let(:cubedefinition) {
    File.read(RSPEC_APP_PATH.join('fixtures','cube_definition.xml'))
  }
  let(:connection) {
    Mondrian::CubeClient.connection("http://192.168.178.104:8080/mondrian/cubecrudapi")
  }
  it "sets the host and port for a connection" do
    expect(connection.base_url).to eq("http://192.168.178.104:8080/mondrian/cubecrudapi")
  end

  describe 'show cube' do
    it "gets a cube's definition" do
      expect(connection.get('mycat', 'mycube')).to eq("")
    end
  end

  describe 'update cube' do

  end

  describe 'create cube' do
    it "creates a cube" do
      expect(connection.create('mycat','mycube',cubedefinition)).to eq("")
    end
  end

  describe 'delete cube' do

  end

  describe 'list cubes in catalog' do

  end

end