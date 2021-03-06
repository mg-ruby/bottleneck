
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "bottleneck/version"

Gem::Specification.new do |spec|
  spec.name          = "bottleneck"
  spec.version       = Bottleneck::VERSION
  spec.authors       = ["Marat Galiev"]
  spec.email         = ["kazanlug@gmail.com"]

  spec.summary       = "Rate limiter"
  spec.description   = "Simple Redis based Rate Limiter for Rails applications"
  spec.homepage      = "https://github.com/maratgaliev/bottleneck"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.52.1"
  spec.add_development_dependency "rdoc", "~> 6.0"
  spec.add_development_dependency "fakeredis", "~> 0.6"
  spec.add_dependency "redis", "~> 4.0"
  spec.add_dependency "redis-namespace", "~> 1.6"
end
