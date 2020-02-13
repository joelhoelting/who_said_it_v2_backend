class Api::V1::CharactersController < ApplicationController
  before_action :set_character, :only => [:show]
  skip_before_action :authorized, :only => [:index, :show]

  # GET /characters
  def index
    @characters = Character.all

    render :json => @characters
  end
end
