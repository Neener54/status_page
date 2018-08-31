
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "status_page/version"

Gem::Specification.new do |spec|
  spec.name          = "status_page"
  spec.version       = StatusPage::VERSION
  spec.authors       = ["Michael"]
  spec.email         = ["micharch54@gmail.com"]

  spec.summary       = %q{Gem to support Statuspage.io in rack apps.}
  spec.description   = %q{Gem to simplify getting your rack/rails app to report to statuspage.io}
  spec.homepage      = "https://github.com/neener54/status_page"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "redis", ">= 3.2"
  spec.add_dependency "rack"
  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "sinatra"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack-test", "~> 1.0"
end
