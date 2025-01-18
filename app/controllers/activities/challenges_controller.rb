class Activities::ChallengesController < Activities::BaseController
  before_action :set_challenge, only: %i[ edit update destroy ]

  def index
    @challenges = @activity.challenges.page(params[:page]).default_order
    active = params&.dig(:active)
    @challenges =
      case active
      when "true"
        @challenges.where(active: true)
      when "false"
        @challenges.where(active: false)
      else
        @challenges
      end
  end

  def new
    @challenge = @activity.challenges.build
  end

  def create
    @challenge = @activity.challenges.build(challenge_params)
    if @challenge.save
      redirect_to edit_activity_url(@activity), notice: "小さな挑戦を作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to edit_activity_url(@activity), notice: "小さな挑戦を更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @challenge.destroy!
    redirect_to edit_activity_url(@activity), notice: "小さな挑戦を削除しました。", status: :see_other
  end

  private

  def set_challenge
    @challenge = @activity.challenges.find(params.expect(:id))
  end

  def challenge_params
    params.expect(challenge: %i[ name description perform_at performed_at active ])
  end
end
