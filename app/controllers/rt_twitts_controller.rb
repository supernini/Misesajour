class RtTwittsController < ApplicationController
  def show
    @rss_provider = RssProvider.find(params[:id])

    @rt_twitt = @rss_provider.rt_twitts.build()
    @user_twitters = current_user.user_twitters.all
    if params[:src]=='ajax'
      render 'show', :layout => false
    else
      render 'show'
    end
  end

  def create
    @rss_provider = RssProvider.find(params[:rt_twitt][:rss_provider_id])
    @rss_provider.rt_twitts.clear
    for user_twitter_id in params[:rt_twitt][:user_twitter_ids]
      @rss_provider.rt_twitts.build(:user_twitter_id => user_twitter_id, :frequence => params[:rt_twitt][:frequence][user_twitter_id])
    end
    @rss_provider.save
    params[:src]=='ajax'
    @rss_providers = current_user.rss_providers.all
    render :template => "rss_providers/index", :layout => false
  end
end
