class AddColumnToMovie < ActiveRecord::Migration[6.0]
  def change
    add_column :movies, :actors, :string
  end
end
