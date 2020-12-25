class Api::V1::GamesController < ApplicationController
	skip_before_action :authorized, :only => [:create, :update]

	# Authorized
	
	def index
		@games = current_user.games.where("completed = true")
		return render :json => @games
	end
	
	def show
		@game = Game.find(params[:id])
		render :json => @game.parsed_game_state
	end

	# Unauthorized

	def create
		@game = Game.new(:difficulty => game_params[:difficulty])
		@game.add_characters_by_id(game_params[:characters])

    # Associate game with current user if user is logged in
		@game.user = current_user if logged_in?

		if @game.valid?
			@game.save
      return render :json => @game.self_with_restricted_game_quotes, :status => 201
    end

    render :json => { :error_msg => @game.errors }, :status => :not_acceptable 
	end

	def update
		@game = Game.find(params[:id])

		if @game.completed
			return render :json => { :error_msg => 'Resource cannot be modified' }, :status => :forbidden
		end
		
		@updated_game = @game.check_answer_and_update(answer_params)

		if @updated_game
			render :json => @updated_game, :status => :ok
		else
			render :json => { :error_msg => 'There was an issue updating the resource' }, :status => :not_acceptable
		end
  end

	private

	def answer_params
		params.require(:game).require(:answer).permit(:character_id, :quote_id, :quote_idx)
	end

	def game_params
		params.require(:game).permit(:difficulty, :characters => [])
	end
end
