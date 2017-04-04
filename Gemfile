source 'https://rubygems.org'
ruby '2.3.3'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.1'
gem 'pg'
gem 'devise'
gem 'cancan'
gem 'database_cleaner'
gem 'cucumber-rails', require: false
gem 'selenium-webdriver'
gem 'time_difference', '~> 0.5.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'responders'
gem 'react-rails'
gem 'carrierwave'
gem 'mini_magick'

group :production do
  gem 'unicorn'
end


group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'annotate'
  # detect N+1 queries and such
  gem 'bullet'
end

group :test do
  gem 'webmock'
  gem 'pusher-fake'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails'
end