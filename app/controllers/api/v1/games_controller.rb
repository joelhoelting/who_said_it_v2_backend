class Api::V1::GamesController < ApplicationController
  skip_before_action :authorized, only: [:create]

	def create
    @game = Game.new(difficulty_params)
		@game.add_characters_by_id(character_params[:characters])

    # Associate game with user if user is logged in
		@game.user = current_user if logged_in?
    if @game.valid?
			@game.save
      return render json: @game, status: 201
    end

    render json: { error: @game.errors }, status: :not_acceptable 
	end

	def save
		@game = Game.find(postgame_params[:id])
		@game.update(state: postgame_params[:state], completed: true)
	end

	def index
		@games = Game.all
		render json: @games
	end

	def show
		@game = Game.find(params[:id])
		render json: @game
	end

	private

	def character_params
		params.permit(:characters => [])
	end

	def difficulty_params
		params.permit(:difficulty)
	end
end
