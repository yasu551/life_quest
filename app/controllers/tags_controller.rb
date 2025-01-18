class TagsController < ApplicationController
  active_menu :tag
  before_action :set_tag, only: %i[ edit update destroy ]

  def index
    @tags = Current.user.tags.default_order
  end

  def new
    @tag = Current.user.tags.build
  end

  def create
    @tag = Current.user.tags.build(tag_params)

    if @tag.save
      redirect_to tags_url, notice: "タグを作成しました。", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_url, notice: "タグを更新しました。", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy!
    redirect_to tags_path, notice: "タグを削除しました。", status: :see_other
  end

  private

  def set_tag
    @tag = Current.user.tags.find(params.expect(:id))
  end

  def tag_params
    params.expect(tag: %i[ name color ])
  end
end
