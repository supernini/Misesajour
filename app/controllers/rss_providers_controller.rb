class RssProvidersController < ApplicationController
  layout 'private'
  before_filter :check_allowed, :only => [:new, :create]

  def check_allowed
    redirect_to dashboard_path if !current_user.can_add_rss_provider
  end

  # GET /rss_providers
  # GET /rss_providers.json
  def index
    @rss_providers = current_user.rss_providers.all

    if params[:src]=='ajax'
      render 'index', :layout => false
    else
      render 'index'
    end
  end

  # GET /rss_providers/1
  # GET /rss_providers/1.json
  def show
    @rss_provider = RssProvider.find(params[:id])
    @rss_provider.load_and_update
    params[:src]='ajax'
    index
  end

  # GET /rss_providers/new
  # GET /rss_providers/new.json
  def new
    @rss_provider = current_user.rss_providers.build(:lastdownload => 0)

    render :layout => false if params[:src]=='ajax'
  end

  # GET /rss_providers/1/edit
  def edit
    @rss_provider = RssProvider.find(params[:id])
    render :layout => false if params[:src]=='ajax'
  end

  # POST /rss_providers
  # POST /rss_providers.json
  def create
    @rss_provider =  current_user.rss_providers.build(params[:rss_provider])

    if @rss_provider.valid? and @rss_provider.save
      @rss_provider.load_and_update
      index
    else
      render action: "new", :layout => false
    end
  end

  # PUT /rss_providers/1
  # PUT /rss_providers/1.json
  def update
    @rss_provider = RssProvider.find(params[:id])

    if @rss_provider.update_attributes(params[:rss_provider])
      @rss_provider.load_and_update
      index
    else
      @rss_provider.update_attribute('failcount', @rss_provider.failcount + 1) if @rss_provider.errors[:url]
      render action: "edit", :layout => false
    end
  end

  # DELETE /rss_providers/1
  # DELETE /rss_providers/1.json
  def destroy
    @rss_provider = RssProvider.find(params[:id])
    @rss_provider.destroy
    params[:src] = 'ajax'
    index
  end
end
