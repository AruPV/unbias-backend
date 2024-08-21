require "clerk/authenticatable"

class ApplicationController < ActionController::API
  include Clerk::Authenticatable
end
