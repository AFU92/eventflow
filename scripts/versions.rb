require "rails"
require "bundler"

abort "Expected Ruby 4.0.7, got #{RUBY_VERSION}" unless RUBY_VERSION == "4.0.7"
abort "Expected Rails 8.1.4, got #{Rails.version}" unless Rails.version == "8.1.4"
abort "Expected Bundler 4.0.22, got #{Bundler::VERSION}" unless Bundler::VERSION == "4.0.22"

puts "Ruby: #{RUBY_VERSION} | Rails: #{Rails.version} | Bundler: #{Bundler::VERSION}"
puts "Gem home: #{Gem.dir}"
