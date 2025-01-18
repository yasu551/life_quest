class ApplicationController < ActionController::Base
  include Authentication
  include MenuActivatable

  allow_browser versions: :modern
end
