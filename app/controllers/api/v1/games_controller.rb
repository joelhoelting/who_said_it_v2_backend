class Api::V1::GamesController < ApplicationController
	skip_before_action :authorized, :only => [:create, :check_answer, :update]
	
	# Authenticated - game belonging to user
	def show
		@game = Game.find(params[:id])
		render :json => render_game_state(@game.state)
	end

	def create
    @game = Game.new(:difficulty => game_params[:difficulty])
		@game.add_characters_by_id(game_params[:characters])

    # Associate game with current user if user is logged in
		@game.user = current_user if logged_in?

    if @game.valid?
			@game.save
      return render :json => @game, :status => 201
    end

    render :json => { :error_msg => @game.errors }, :status => :not_acceptable 
	end

	def update
		@game = Game.find(params[:id])

		if @game.completed
			return render :json => { :error_msg => 'Resource cannot be modified'}, :status => :forbidden
		end
		
		# 'update_game' helper method -- concerns/games_helper.rb
		render :json => @game.check_answer_and_update(answer_params)
  end

	# Authenticated - User games
	def index
		if current_user
			@games = current_user.games.where("completed = true")
			return render json: @games
		end
		
		render json: { :error_msg => 'Resource requires authorization' }, :status => :unauthorized
	end

	private

	def answer_params
		params.require(:answer).permit(:character_id, :quote_id, :quote_idx)
	end

	def game_params
		params.require(:game).permit(:difficulty, :characters => [])
	end
end
