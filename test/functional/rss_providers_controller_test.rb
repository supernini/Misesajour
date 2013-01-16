require 'test_helper'

class RssProvidersControllerTest < ActionController::TestCase
  setup do
    @rss_provider = rss_providers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rss_providers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rss_provider" do
    assert_difference('RssProvider.count') do
      post :create, rss_provider: { frequence: @rss_provider.frequence, last_run: @rss_provider.last_run, name: @rss_provider.name, run_count: @rss_provider.run_count, twitt_prefix: @rss_provider.twitt_prefix, twitt_suffix: @rss_provider.twitt_suffix }
    end

    assert_redirected_to rss_provider_path(assigns(:rss_provider))
  end

  test "should show rss_provider" do
    get :show, id: @rss_provider
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rss_provider
    assert_response :success
  end

  test "should update rss_provider" do
    put :update, id: @rss_provider, rss_provider: { frequence: @rss_provider.frequence, last_run: @rss_provider.last_run, name: @rss_provider.name, run_count: @rss_provider.run_count, twitt_prefix: @rss_provider.twitt_prefix, twitt_suffix: @rss_provider.twitt_suffix }
    assert_redirected_to rss_provider_path(assigns(:rss_provider))
  end

  test "should destroy rss_provider" do
    assert_difference('RssProvider.count', -1) do
      delete :destroy, id: @rss_provider
    end

    assert_redirected_to rss_providers_path
  end
end
