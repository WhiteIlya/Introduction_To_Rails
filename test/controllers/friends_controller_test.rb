require "test_helper"

class Api::FriendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @friend = friends(:one) # fixtures for friends
    @user = users(:one)  # fixtures for users
    @token = JWT.encode({ user_id: @user.id }, Rails.application.credentials.secret_key_base)  # JWT generation
  end

  # GET /friends
  test "should get index" do
    get api_friends_url, headers: { Authorization: "Bearer #{@token}" }, as: :json
    assert_response :success
    assert_match "application/json", @response.content_type
  end

  # GET /friends/1
  test "should show friend" do
    get api_friend_url(@friend), headers: { Authorization: "Bearer #{@token}" }, as: :json
    assert_response :success
    assert_match "application/json", @response.content_type
  end

  # POST /friends
  test "should create friend" do
    assert_difference("Friend.count") do
      post api_friends_url, params: { friend: { email: "new_email@example.com", first_name: "New", last_name: "Friend", phone: "1234567890", twitter: "@new_friend" } }, headers: { Authorization: "Bearer #{@token}" }, as: :json
    end

    assert_response :created
  end

  # PATCH/PUT /friends/1
  test "should update friend" do
    patch api_friend_url(@friend), params: { friend: { email: "updated_email@example.com", first_name: "Updated", last_name: "Friend", phone: "0987654321", twitter: "@updated_friend" } }, headers: { Authorization: "Bearer #{@token}" }, as: :json
    assert_response :ok
  end

  # DELETE /friends/1
  test "should destroy friend" do
    assert_difference("Friend.count", -1) do
      delete api_friend_url(@friend), headers: { Authorization: "Bearer #{@token}" }, as: :json
    end

    assert_response :no_content
  end

  # GET /friends but with outdated token
  test "should not authorize with expired token" do
    expired_token = JWT.encode({ user_id: @user.id, exp: 1.hour.ago.to_i }, Rails.application.credentials.secret_key_base)
    get api_friends_url, headers: { Authorization: "Bearer #{expired_token}" }, as: :json
    assert_response :unauthorized
  end
end
