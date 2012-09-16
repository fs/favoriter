source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.8'
gem 'jquery-rails'
gem 'mongoid', '>= 3.0.3'
gem 'omniauth', '>= 1.1.0'
gem 'omniauth-twitter'
gem 'twitter'
gem 'memcache-client'
gem 'rinku'


group :assets do
  gem 'less-rails', '~> 2.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', '~> 2.1.0'
  gem 'jquery-rails'
end

group :development do
  gem 'foreman'
  gem 'heroku'
end

group :test do
  gem 'database_cleaner', '>= 0.8.0'
  gem 'mongoid-rspec', '>= 1.4.6'
  gem 'cucumber-rails', '>= 1.3.0', :require => false
  gem 'launchy', '>= 2.1.2'
  gem 'capybara', '>= 1.1.2'
end

group :development, :test do
  gem 'rspec-rails', '>= 2.11.0'
  gem 'factory_girl_rails', '>= 4.0.0'
  gem 'dotenv'
end

group :development, :production do
  gem 'thin'
  gem 'awesome_print'
end
