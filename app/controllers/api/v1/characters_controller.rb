class Api::V1::CharactersController < ApplicationController
  skip_before_action :authorized, :only => [:index, :test]

  def test
    render :json => { :test => "Hello World"}
  end

  # GET /characters
  def index
    @characters = Character.all

    render :json => @characters
  end

end
