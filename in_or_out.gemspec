# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require File.expand_path('../lib/in_or_out/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "in_or_out"
  gem.authors       = ["Aaron Ciaghi"]
  gem.email         = ["aaron.ciaghi@gmail.com"]
  gem.summary       = %q{This is a very simple Ruby script to label a set of points according to their location inside given areas.}
  # gem.description   = %q{Longer description of your project.}
  gem.homepage      = "https://github.com/aaronsama/in_or_out"
  gem.license       = "MIT"

  gem.files         = %x{git ls-files}.split($\)
  gem.executables   = ['in_or_out']
  # gem.test_files    = ['tests/test_NAME.rb']
  gem.require_paths = ["lib"]
  gem.version       = InOrOut::VERSION

  gem.add_runtime_dependency 'border_patrol', ['>= 0.2.1']
end
