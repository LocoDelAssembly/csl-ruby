source :rubygems
gemspec

group :debug do
  gem 'ruby-debug', :platforms => [:ruby_18, :jruby]
  gem 'ruby-debug19', :require => 'ruby-debug', :platforms => [:ruby_19]
end

group :optional do
  gem 'nokogiri', '~>1.5'
end

# vim: syntax=ruby