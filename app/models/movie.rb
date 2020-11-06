class Movie < ApplicationRecord
    has_many :watch_list_movies
    has_many :watch_lists, through: :watch_list_movies

    validates :title, presence: true, uniqueness: { scope: :release_year}
    validates :description, :release_year, :mpaa_rating, :genre, presence: true

    def self.genre_name(genres)
        where(genre: genres.downcase)
    end
    
end
