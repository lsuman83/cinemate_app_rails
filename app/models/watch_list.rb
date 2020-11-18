class WatchList < ApplicationRecord
  belongs_to :user
  has_many :watch_list_movies
  has_many :movies, through: :watch_list_movies
  has_many :watched_movies, -> { where(watch_list_movies: {watched: true}) },
  through: :watch_list_movies, source: :movie
  has_many :unwatched_movies, -> { where(watch_list_movies: {watched: false}) },
  through: :watch_list_movies, source: :movie

  validates :name, presence: true, uniqueness: true

  

end
