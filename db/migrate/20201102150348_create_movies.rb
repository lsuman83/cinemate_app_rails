class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :release_year
      t.string :mpaa_rating
      t.text :description
      t.string :genre

      t.timestamps
    end
  end
end
