class WatchListMovie < ApplicationRecord
  belongs_to :watch_list
  belongs_to :movie

  validates :watched, presence: true

  scope(:watched) -> { where(watched: true) }

  def self.watched
    where(watched: true)
  end

  def self.unwatched
    where(watched: false)
  end

  def self.genre_name(genres)
    included(:movies).where(genre: genres)
  end

end
