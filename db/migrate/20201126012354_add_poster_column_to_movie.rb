class AddPosterColumnToMovie < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :poster, :text
  end
end
