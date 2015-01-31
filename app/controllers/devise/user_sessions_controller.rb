class Devise::UserSessionsController < Devise::SessionsController
  before_filter :set_ng_app

  def set_ng_app
    super 'deviseApp'
  end
end
