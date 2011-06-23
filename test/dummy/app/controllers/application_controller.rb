class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :xml
end
