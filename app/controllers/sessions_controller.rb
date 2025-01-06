class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "後で、再トライしてください。" }

  def new
    @user = User.new
  end

  def create
    user = User.authenticate_by(params.expect(user: %i[ email_address password ]))
    if user.present?
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_url, alert: "メールアドレスまたはパスワードが正しくありません。"
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_url
  end
end
