class WatchListMovie < ApplicationRecord
  belongs_to :watch_list
  belongs_to :movie

  validates :watched, inclusion: [true, false]

  scope :watched, -> { where(watched: true) }

  scope :unwatched, -> { where(watched: false) }


end
