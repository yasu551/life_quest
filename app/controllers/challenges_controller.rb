class ChallengesController < ApplicationController
  active_menu :challenge

  def index
    @challenges = Current.user.challenges.page(params[:page]).default_order
    scope_chains = params&.dig(:scope_chains)
    if scope_chains.present?
      @challenges = @challenges.applied_scopes(scope_chains)
    end
  end
end
