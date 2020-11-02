class CreateWatchListMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :watch_list_movies do |t|
      t.boolean :watched
      t.references :watch_list, null: false, foreign_key: true
      t.references :movie, null: false, foreign_key: true

      t.timestamps
    end
  end
end
