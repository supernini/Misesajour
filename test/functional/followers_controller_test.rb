require 'test_helper'

class FollowersControllerTest < ActionController::TestCase
  setup do
    @follower = followers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:followers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create follower" do
    assert_difference('Follower.count') do
      post :create, follower: { follow_request_send: @follower.follow_request_send, followers_count: @follower.followers_count, following: @follower.following, friends_count: @follower.friends_count, id: @follower.id, lang: @follower.lang, last_tweet_date: @follower.last_tweet_date, name: @follower.name, screen_name: @follower.screen_name, status_count: @follower.status_count, url: @follower.url }
    end

    assert_redirected_to follower_path(assigns(:follower))
  end

  test "should show follower" do
    get :show, id: @follower
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @follower
    assert_response :success
  end

  test "should update follower" do
    put :update, id: @follower, follower: { follow_request_send: @follower.follow_request_send, followers_count: @follower.followers_count, following: @follower.following, friends_count: @follower.friends_count, id: @follower.id, lang: @follower.lang, last_tweet_date: @follower.last_tweet_date, name: @follower.name, screen_name: @follower.screen_name, status_count: @follower.status_count, url: @follower.url }
    assert_redirected_to follower_path(assigns(:follower))
  end

  test "should destroy follower" do
    assert_difference('Follower.count', -1) do
      delete :destroy, id: @follower
    end

    assert_redirected_to followers_path
  end
end
