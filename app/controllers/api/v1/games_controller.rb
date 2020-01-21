class Api::V1::GamesController < ApplicationController
	include GamesHelper
	skip_before_action :authorized, :only => [:create, :check_answer, :update]
	
	# Authenticated - game belonging to user
	def show
		@game = Game.find(params[:id])
		render :json => @game
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

    render :json => { :error => @game.errors }, :status => :not_acceptable 
	end

	def update
		@game = Game.find(params[:id])

		if @game.completed
			return render :json => { :response => 'Resource cannot be altered'}, :status => :forbidden
		end
		
		# 'update_game' helper method
		return render :json => update_game(@game, answer_params)
  end

	# Authenticated - all games belonging to user
	def index
		@games = Game.all
		render json: @games
	end

	private

	def answer_params
		params.require(:answer).permit(:character_id, :quote_id, :quote_idx)
	end

	def character_id_params
		params.permit(:characters => [])
	end

	def difficulty_params
		params.permit(:difficulty)
	end
end
