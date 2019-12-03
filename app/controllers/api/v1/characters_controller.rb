class Api::V1::CharactersController < ApplicationController
  before_action :set_character, only: [:show, :update, :destroy]
  skip_before_action :authorized, only: [:index, :show]

  # GET /characters
  def index
    @characters = Character.all

    render json: @characters
  end

  # GET /characters/1
  def show
    render json: @character
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def character_params
      params.fetch(:character, {})
    end
end
