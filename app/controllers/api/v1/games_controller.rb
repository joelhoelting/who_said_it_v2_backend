class Api::V1::GamesController < ApplicationController
  skip_before_action :authorized, :only => [:create, :check_answer]

	def create
    @game = Game.new(difficulty_params)
		@game.add_characters_by_id(characters_params[:characters])

    # Associate game with user if user is logged in
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

	# Authenticated - game belonging to user
	def show
		@game = Game.find(params[:id])
		render json: @game
	end

	def check_answer
		# 1. get quote id
		# 2. get character selected
		# 3. responds with correct add_characters_by_id
		@quote = Quote.find(quote_params[:id])
		@character = Character.find(character_params[:id])
		
		@json = { :evaluation => @quote.character == @character, :correct_character => @quote.character }
		
		return render :json => @json, status: :ok
	end

	private

	def character_params
		params.require(:character).permit(:id, :description, :name, :slug)
	end

	def characters_params
		params.permit(:characters => [])
	end

	def quote_params
		params.require(:quote).permit(:id, :content)
	end

	def difficulty_params
		params.permit(:difficulty)
	end
end
