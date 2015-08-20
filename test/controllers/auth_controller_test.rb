require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  def setup
    super
    outgoing_mail.clear
  end

  def test_magic_email_send
    su = create :user, email: "su@theironyard.com"
    post :send_ios_login_email, email: "su"
    assert_response :success

    assert_equal 1, outgoing_mail.count
    mail = outgoing_mail.last
    assert_equal ["su@theironyard.com"], mail.to
    assert_includes mail.body.to_s, su.ios_login_link
    refute_includes mail.body.to_s.downcase, "changed"
  end

  def test_email_send_bad_email
    assert_raises ActiveRecord::RecordNotFound do
      post :send_ios_login_email, email: "not_a_person"
    end
    assert_equal 0, outgoing_mail.count
  end
end
