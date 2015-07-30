require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  def test_users_must_be_authenticated
    get :show, id: SlackTeam.staff.id, format: :json
    assert_equal 401, response.status
    assert response.json[:error]
  end
end
