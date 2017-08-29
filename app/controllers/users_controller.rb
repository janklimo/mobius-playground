# frozen_string_literal: true

class UsersController < ApplicationController
  def dashboard
    @user = current_user
    @users = User.regular - [@user]
  end
end
