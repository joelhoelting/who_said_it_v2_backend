characters = [
  # Adolf Hitler
  {
    :filename => "adolf_hitler",
    :name => "Adolf Hitler",
    :description => "Leader of the Nazi Party, mass-murderer and the most infamous white supremacist in world history."
  },
  # Bill Hicks
  {
    :filename => "bill_hicks",
    :name => "Bill Hicks",
    :description => "Stand-up comedian, chain smoker and raging misanthropist."
  },
  # Donald Trump
  {
    :filename => "donald_trump",
    :name => "Donald Trump",
    :description => "45th U.S. President. Eats pizza with a fork and knife. Potential harbinger of the apocalypse."
  },
  # George Bush
  {
    :filename => "george_bush",
    :name => "George Bush",
    :description => "43rd U.S. President, meme-friendly war criminal and professional shoe dodger."
  },
  # George Carlin
  {
    :filename => "george_carlin",
    :name => "George Carlin",
    :description => "Stand-up Comedian, renowned cynic. Made the bald ponytail fashionable again."
  },
  # God
  {
    :filename => "god",
    :name => "God",
    :description => "Allegedly created the universe in 6 days. Known to get into fits of jealous rage."
  },
  # Joseph Stalin
  {
    :filename => "joseph_stalin",
    :name => "Joseph Stalin",
    :description => "Ex-Soviet Leader and prize-winning political repressor."
  },
  # Henry Kissinger
  {
    :filename => "henry_kissinger",
    :name => "Henry Kissinger",
    :description => "56th Secretary of State, Committed Genocide with a heir of pretention and swagger."
  },
  # Mr. Burns
  {
    :filename => "mr_burns",
    :name => "Mr. Burns",
    :description => "Nuclear Power Plant Owner, trap door activator and ruthless businessman."
  },
  # Mr. Krabs
  {
    :filename => "mr_krabs",
    :name => "Mr. Krabs",
    :description => "Stand-up Comedian, renowned cynic. Made the bald ponytail fashionable again."
  },
  # Noam Chomsky
  {
    :filename => "noam_chomsky",
    :name => "Noam Chomsky",
    :description => "Social-critic, World Renowned Intellectual"
  },
  # Stewie Griffin
  {
    :filename => "stewie_griffin",
    :name => "Stewie Griffin",
    :description => "Deranged matricidal infant with a cuddly side."
  },
]

def character_import(filename, name, description)
  if Character.find_by(name: name).nil?
    character = Character.create(
      slug: filename,
      name: name,
      description: description
    )
    
    json = ActiveSupport::JSON.decode(File.read("db/seeds/quotes/#{filename}.json"))
    json.each do |key, value|
      value.each do |quote|
        if Quote.find_by(content: quote["content"]).nil?
          Quote.create(content: quote["content"], source: quote["source"], character_id: character.id)
        end
      end
    end
    puts "#{character.name} Seeded"
  else
    puts "#{Character.find_by(name: name).name} already exists, skip seeding"
  end
	
end

characters.each do |character|
  character_import(character[:filename], character[:name], character[:description])
end

character_count = Character.all.count
quote_count = Quote.all.count

puts "Total Characters: #{character_count}, Total Quotes: #{quote_count}"

# game = Game.new(
#   difficulty: "easy",
#   state:
#    [
#       { :correct_character=>6, :selected_character=>5, :quote=>205, :evaluation=>false },
#       { :correct_character=>5, :selected_character=>6, :quote=>156, :evaluation=>false },
#       { :correct_character=>5, :selected_character=>5, :quote=>178, :evaluation=>true },
#       { :correct_character=>6, :selected_character=>6, :quote=>197, :evaluation=>true },
#       { :correct_character=>5, :selected_character=>5, :quote=>163, :evaluation=>true },
#       { :correct_character=>6, :selected_character=>5, :quote=>205, :evaluation=>false },
#       { :correct_character=>5, :selected_character=>6, :quote=>156, :evaluation=>false },
#       { :correct_character=>5, :selected_character=>5, :quote=>178, :evaluation=>true },
#       { :correct_character=>6, :selected_character=>6, :quote=>197, :evaluation=>true },
#       { :correct_character=>5, :selected_character=>5, :quote=>163, :evaluation=>true }
#   ],
#   ten_quote_ids: [205, 156, 178, 197, 163, 188, 183, 198, 161, 181],
#   completed: true,
#   user_id: 9,
# )

# character1 = Character.find(5)
# character2 = Character.find(6)

# game.characters = [character1, character2]
# game.save