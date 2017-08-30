# frozen_string_literal: true

class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @users = User.regular - [@user]
    @transactions = @user
      .all_transactions
      .with_preloaded_users
      .sorted
      .limit(5)
  end
end
