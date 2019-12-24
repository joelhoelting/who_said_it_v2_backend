class Api::V1::GamesController < ApplicationController
	before_action :set_game, :only => [:show, :update]
	skip_before_action :authorized, :only => [:create, :check_answer]
	
	# Authenticated - game belonging to user
	def show
		@game = Game.find(params[:id])
		render json: @game
	end

	def create
    @game = Game.new(difficulty_params)
		@game.add_characters_by_id(character_id_params[:characters])

    # Associate game with current user if user is logged in
		@game.user = current_user if logged_in?

    if @game.valid?
			@game.save
      return render :json => @game, :status => 201
    end

    render json: { :error => @game.errors }, :status => :not_acceptable 
	end

	def save
		@game = Game.find(postgame_params[:id])
		@game.update(:state => postgame_params[:state], :completed => true)
	end

	# Authenticated - all games belonging to user
	def index
		@games = Game.all
		render json: @games
	end

	def check_answer
		@character = Character.find(answer_params[:character_id])	
		@quote = Quote.find(answer_params[:quote_id])

		@json = { 
			:evaluation => @quote.character.id == @character.id, 
			:correct_character => @quote.character.strip_character_params,
		}
		
		return render :json => @json, status: :ok
	end

	private

	def postgame_params
		params.require(:postgame).permit(:state, :completed)
	end

	def answer_params
		params.require(:answer).permit(:character_id, :quote_id)
	end

	def character_id_params
		params.permit(:characters => [])
	end

	def difficulty_params
		params.permit(:difficulty)
	end
end
