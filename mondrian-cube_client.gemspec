# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mondrian/cube_client/version'

Gem::Specification.new do |spec|
  spec.name          = "mondrian-cube_client"
  spec.version       = Mondrian::CubeClient::VERSION
  spec.authors       = ["Peter Schrammel"]
  spec.email         = ["peter.schrammel@metoda.com"]

  spec.summary       = %q{ mondrian api wrapper}
  spec.description   = %q{ Wrapper for connecting to mondrian OLAP server}
  spec.homepage      = "https://github.com/preisanalytics/mondrian-cube_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
