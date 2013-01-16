require 'test_helper'

class UserTwittersControllerTest < ActionController::TestCase
  setup do
    @user_twitter = user_twitters(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_twitters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_twitter" do
    assert_difference('UserTwitter.count') do
      post :create, user_twitter: { image_url: @user_twitter.image_url, provider: @user_twitter.provider, public_token: @user_twitter.public_token, twitter_secret_token: @user_twitter.twitter_secret_token, twitter_token: @user_twitter.twitter_token, uid: @user_twitter.uid, username: @user_twitter.username }
    end

    assert_redirected_to user_twitter_path(assigns(:user_twitter))
  end

  test "should show user_twitter" do
    get :show, id: @user_twitter
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_twitter
    assert_response :success
  end

  test "should update user_twitter" do
    put :update, id: @user_twitter, user_twitter: { image_url: @user_twitter.image_url, provider: @user_twitter.provider, public_token: @user_twitter.public_token, twitter_secret_token: @user_twitter.twitter_secret_token, twitter_token: @user_twitter.twitter_token, uid: @user_twitter.uid, username: @user_twitter.username }
    assert_redirected_to user_twitter_path(assigns(:user_twitter))
  end

  test "should destroy user_twitter" do
    assert_difference('UserTwitter.count', -1) do
      delete :destroy, id: @user_twitter
    end

    assert_redirected_to user_twitters_path
  end
end
