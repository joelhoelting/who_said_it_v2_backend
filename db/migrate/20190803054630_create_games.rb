class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :difficulty
      t.text :state
      t.text :ten_quote_ids
      t.boolean :completed, :default => false
      t.references :user, :foreign_key => true

      t.timestamps
    end
  end
end
