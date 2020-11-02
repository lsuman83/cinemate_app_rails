class Movie < ApplicationRecord
    has_many :watch_list_movies
    has_many :watch_lists, through: :watch_list_movies

    validations :title, :description, :release_year, :mpaa_rating, :genre, presence: true
end
