class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update]
    before_action :require_same_user, only: [:edit, :update, :destroy]

    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 5)
    end

    def new
        @user = User.new
    end

    def edit
    end

    def update
        if @user.update(user_params)
            flash[:notice] = "Your account information was successfully updated"
            redirect_to @user
        else
            render "edit"
        end
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
            flash[:notice] = "Welcome to the fraud tracker!"
            redirect_to root_path
        else
            render 'new'
        end
    end

    def destroy
        @user.destroy
        session.delete(:user_id) if @user == current_user
        flash[:alert] = "Your account and all articles were deleted"
        redirect_to users_path
    end

    def index
        # @users = User.all
        @users = User.paginate(page: params[:page], per_page: 5)
    end

    def permissions
        @users = User.all
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(:username, :email, :password)
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert] = "You can only edit your own profile"
            redirect_to @user
        end
    end

end
