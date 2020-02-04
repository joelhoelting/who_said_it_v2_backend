module GamesHelper
  def render_game_state(state)
    parsed_state = state.map do |state_item|
      correct_character = Character.find(state_item[:correct_character])
      selected_character = Character.find(state_item[:selected_character])
      quote = Quote.find(state_item[:quote])
      evaluation = state_item[:evaluation]

      {
        :evaluation => evaluation,
        :correct_character => correct_character, 
        :selected_character=> selected_character,
        :quote => quote
      }
    end
    
    return parsed_state
  end

  def update_game(game, params)
    character = Character.find(params[:character_id])	
		quote = Quote.find(params[:quote_id])
    quote_idx = params[:quote_idx]
    completed = quote_idx == 9

		game_state_hash = {
			:correct_character => quote.character.id,
			:selected_character => character.id,
			:quote => quote.id,
			:evaluation => quote.character.id == character.id
    }
    
    game.update(:state => game.state << game_state_hash, :completed => completed)

		{ 
			:evaluation => quote.character.id == character.id,
			:correct_character => quote.character.strip_character_params,
			:selected_character => character.strip_character_params,
      :state => render_game_state(game.state),
      :completed => completed
		}
  end
end