class CreateCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :characters do |t|
      t.string :slug
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
