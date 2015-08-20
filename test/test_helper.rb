ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

begin
  DatabaseCleaner.start
  FactoryGirl.lint
ensure
  DatabaseCleaner.clean
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  def outgoing_mail
    ActionMailer::Base.deliveries
  end
end

class ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
end

class ActionDispatch::Response
  def json
    @_json ||= JSON.parse(body).with_indifferent_access
  end
end
