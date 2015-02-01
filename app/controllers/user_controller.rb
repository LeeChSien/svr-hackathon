class UserController < ApplicationController
  before_filter :set_ng_app

  def visit
    @user = User.find(params[:id])
  end

  private

    def set_ng_app
      super 'dishApp'
    end
end
