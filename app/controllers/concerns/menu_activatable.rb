module MenuActivatable
  extend ActiveSupport::Concern

  included do
    helper_method :active_menu?
  end

  class_methods do
    def active_menu(menu, options = {})
      before_action -> { active_menu(menu) }, options
    end
  end

  def active_menu(menu)
    @active_menu = menu.to_sym
  end

  def active_menu?(menu)
    @active_menu == menu.to_sym
  end
end
