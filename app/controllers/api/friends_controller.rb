class Api::FriendsController < ApiController
  before_action :set_friend, only: %i[ show update destroy ]  # Call set_friend befor these actions

  # GET /friends
  def index
    @friends = current_user.friends
    render json: @friends, status: :ok
  end

  # GET /friends/1
  def show
    render json: @friend, status: :ok
  end

  # POST /friends
  def create
    @friend = current_user.friends.build(friend_params)  # Link a new friend to the current user
    if @friend.save
      render json: @friend, status: :created
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /friends/1
  def update
    if @friend.update(friend_params)
      render json: @friend, status: :ok
    else
      render json: @friend.errors, status: :unprocessable_entity
    end
  end

  # DELETE /friends/1
  def destroy
    @friend.destroy!
    head :no_content  # returns 204 status - No Content
  end

  private

    # Cache a friend which is related to the current user
    def set_friend
      @friend = current_user.friends.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Friend not found" }, status: :not_found
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.require(:friend).permit(:first_name, :last_name, :email, :phone, :twitter)
    end
end
