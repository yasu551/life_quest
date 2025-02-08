class PushSubscriptionsController < ApplicationController
  before_action :set_push_subscription

  def create
    if @push_subscription.present?
      @push_subscription.touch
    else
      Current.user.push_subscriptions.create!(push_subscription_params.merge(user_agent: request.user_agent))
    end
    head :ok
  end

  def destroy
    @push_subscription&.destroy!
    head :ok
  end

  private

  def set_push_subscription
    @push_subscription = Current.user.push_subscriptions.find_by(push_subscription_params)
  end

  def push_subscription_params
    params.expect(push_subscription: %i[ endpoint p256dh_key auth_key ])
  end
end
