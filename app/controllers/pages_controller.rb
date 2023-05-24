class PagesController < ApplicationController
  before_bugsnag_notify :add_user_info_to_bugsnag

  def home
    @user = current_user
  end

  private

  def add_user_info_to_bugsnag(event)
    if current_user
      event.set_user(current_user.id.to_s, current_user.email)
    else
      event.set_user("Unknown", "Unknown")
    end
  end
end
