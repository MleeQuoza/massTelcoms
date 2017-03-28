class Api::V1::ToolsController < Api::V1::BaseController
  before_action :authenticate_user!
end