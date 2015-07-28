source 'https://rubygems.org'
ruby '2.2.2'


gem 'rails', '4.2.3'
gem 'pg'

gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.0'
gem 'quiet_assets'
gem 'slim-rails'

gem 'figaro'
gem 'devise'
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-slack'

gem 'twitter-bootstrap-rails'

gem 'slack-api', require: 'slack'

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'rubyXL' # for importing schedule
end

group :development, :test do
  gem 'spring'
end

group :production do
  gem 'rails_12factor'
  gem 'puma'
  gem 'rollbar'
end
