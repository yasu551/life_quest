class Achievements::ChallengesController < Achievements::BaseController
  active_menu :challenge
  before_action :set_challenge, only: %i[ edit update destroy ]

  def index
    @challenges = @achievement.challenges.page(params[:page]).default_order
    scope_chains = params&.dig(:scope_chains)
    if scope_chains.present?
      @challenges = @challenges.applied_scopes(scope_chains)
    end
  end

  def new
    @challenge = @achievement.challenges.build
  end

  def create
    @challenge = @achievement.challenges.build(challenge_params)
    if @challenge.save
      redirect_to edit_achievement_url(@achievement), notice: "小さな挑戦を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to edit_achievement_url(@achievement), notice: "小さな挑戦を更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @challenge.destroy!
    redirect_to edit_achievement_url(@achievement), notice: "小さな挑戦を削除しました。", status: :see_other
  end

  private

  def set_challenge
    @challenge = @achievement.challenges.find(params.expect(:id))
  end

  def challenge_params
    params.expect(challenge: %i[ name description perform_at performed_at active memo])
  end
end
