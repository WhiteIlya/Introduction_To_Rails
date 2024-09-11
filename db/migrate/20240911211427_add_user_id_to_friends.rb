class AddUserIdToFriends < ActiveRecord::Migration[7.2]
  def change
    add_reference :friends, :user, null: false, foreign_key: true
  end
end
