require "clerk/authenticatable"

class ApplicationController < ActionController::API
  include ActionController::Helpers
  include Clerk::Authenticatable
end
