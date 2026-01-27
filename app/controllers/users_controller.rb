class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]
  skip_before_action :authenticate_request, only: %i[ create ]





  # get /users/roles
  def roles
    role = params[:role]
    if role.present?
      @users = User.where(role: role)
    else
      @users = User.all
    end 
    render json: User.respond_to_json(@users)
  end









  # GET /users/search?q=keyword
  # def search
  #   keyword = params[:keyword]
  #   if keyword.present?
  #     @users = User.search(keyword)
  #   else
  #     @users = User.all
  #   end
  #   render json: User.respon_to_json_user(@users)
  # end



  # GET /users/search?keyword=xxx
  # def search
  #   @users = User.search_sql(params[:keyword])
  #   render json: User.respond_to_json(@users)
  # end
  
  def search
    result = User.search_with_pagination(params)
  
    render json: {
      data: result[:users].map { |u|
        {
          id: u.id,
          username: u.username,
          name: u.name,
          role: u.role
        }
      },
      recordsTotal: result[:total],
      recordsFiltered: result[:total]
    }
  end
  









  # GET /users
  # def index
  #   @users = User.all_sql
  #   render json: User.respon_to_json_user(@users)
  # end

  def index
    if params[:keyword].present?
      users = User.search(params[:keyword])
    else
      users = User.list_basic
    end
  
    render json: User.respond_to_json(users)
  end




  

  # GET /users/1
  def show
    render json: @user
  end




  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end






  





  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

  def user_params
    params.require(:user).permit(:username, :name, :password, :password_confirmation, :role)
  end

end
