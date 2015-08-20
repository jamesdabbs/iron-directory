require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def test_api_key_resets
    outgoing_mail.clear

    user = create :user
    old  = user.api_key
    user.reset_api_key!

    assert old
    assert user.api_key
    refute_equal old, user.api_key

    assert_equal 1, outgoing_mail.count
    mail = outgoing_mail.last
    assert_equal [user.email], mail.to
    assert_includes mail.body.to_s, user.ios_login_link
    assert_includes mail.body.to_s.downcase, "login"
  end
end
