source 'https://rubygems.org'

gem 'rails', '~> 8.0.1'

gem 'cssbundling-rails'
# リリースされているdevseiがrails8に対応していないため、mainブランチを指定
gem 'devise', git: 'https://github.com/heartcombo/devise', branch: 'main'
gem 'haml-rails'
gem 'jsbundling-rails'
gem 'pg'
gem 'propshaft'
gem 'puma'
gem 'simple_form'
gem 'stimulus-rails'
gem 'turbo-rails'

gem 'solid_cable'
gem 'solid_cache'
gem 'solid_queue'

gem 'bootsnap', require: false
gem 'kamal', require: false
gem 'thruster', require: false

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'haml_lint'
  gem 'rspec-rails'
  gem 'sgcop', github: 'SonicGarden/sgcop', branch: 'main'
end

group :development do
  gem 'bullet'
  gem 'letter_opener_web'
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'email_spec'
  gem 'selenium-webdriver'
end
