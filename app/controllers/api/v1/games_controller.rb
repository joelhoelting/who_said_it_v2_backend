class Api::V1::GamesController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def create
    @game = Game.new(difficulty_params)
    
    character_ids = characters_array_params[:characters].map {|character| character[:id] }
    @game.add_characters_by_id(character_ids)

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

	def characters_array_params
		params.permit(characters: [:id, :slug])
	end

	def difficulty_params
		params.permit(:difficulty)
	end

	def postgame_params
		params.permit(:id, :state => [])
	end
end
