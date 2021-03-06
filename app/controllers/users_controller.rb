class UsersController < Devise::RegistrationsController

  skip_before_filter :require_no_authentication
  before_filter :require_admin!, :only => [:index, :new, :create]
  before_filter :get_user_and_authenticate, :only => [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    admin = params.delete(:admin)
    @user = User.new(params[:user])
    if admin
      user.admin = true
    end
    if @user.save
      flash[:notice] = "Account registered!"
      redirect_to user_path(@user)
    else
      render :action => :new
    end
  end

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    nil_unused_params
    if current_user.admin?
      if params[:user][:admin]
        @user.update_attribute( :admin, params[:user][:admin] )
      end
      if params[:user][:inactive]
        @user.update_attribute( :inactive, params[:user][:inactive] )
      end
    end
    add_current_project
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
    end
    render :action => :edit
  end

  def nil_unused_params
    [ :password, :password_confirmation].each do |param|
      if params[:user][param] and params[:user][param].blank?
        params[:user].delete(param)
      end
    end
  end

  private
  def get_user_and_authenticate
    Rails.logger.debug params.inspect
    @user = User.find(params[:id])
    require_owner!(@user)
  end

  def add_current_project
    if params[:user].has_key?(:current_project_id)
      @user.current_project_id = params[:user].delete(:current_project_id)
    end
  end
end
