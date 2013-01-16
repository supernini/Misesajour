class UserTwittersController < ApplicationController
  layout 'private'
  before_filter :check_allowed, :only => [:new, :create]

  def check_allowed
    redirect_to dashboard_path if !current_user.can_add_account
  end

  # GET /user_twitters
  # GET /user_twitters.json
  def index
    @user_twitters = current_user.user_twitters.all

    if params[:src]=='ajax'
      render 'index', :layout => false
    else
      render 'index'
    end
  end

  # GET /user_twitters/1
  # GET /user_twitters/1.json
  def show
    @user_twitter = UserTwitter.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_twitter }
    end
  end

  # GET /user_twitters/new
  # GET /user_twitters/new.json
  def new
    @user_twitter = UserTwitter.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_twitter }
    end
  end

  # GET /user_twitters/1/edit
  def edit
    @user_twitter = UserTwitter.find(params[:id])
  end

  # POST /user_twitters
  # POST /user_twitters.json
  def create
    @user_twitter = UserTwitter.new(params[:user_twitter])

    respond_to do |format|
      if @user_twitter.save
        format.html { redirect_to @user_twitter, notice: 'User twitter was successfully created.' }
        format.json { render json: @user_twitter, status: :created, location: @user_twitter }
      else
        format.html { render action: "new" }
        format.json { render json: @user_twitter.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_twitters/1
  # PUT /user_twitters/1.json
  def update
    @user_twitter = UserTwitter.find(params[:id])

    respond_to do |format|
      if @user_twitter.update_attributes(params[:user_twitter])
        format.html { redirect_to @user_twitter, notice: 'User twitter was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_twitter.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_twitters/1
  # DELETE /user_twitters/1.json
  def destroy
    @user_twitter = UserTwitter.find(params[:id])
    @user_twitter.destroy

    respond_to do |format|
      format.html { redirect_to user_twitters_url }
      format.json { head :no_content }
    end
  end
end
