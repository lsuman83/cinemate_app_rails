# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## What is the Many to many relationship and how is it used?
WatchList <=> Movies
```rb
class User
	has_many :watch_lists
	has_many :movies, through: :watch_lists
end 

class WatchList
	belongs_to :user
    has_many :watch_list_movies
    has_many :movies, through: :watch_list_movies    
end

class WatchListMovie
    belongs_to :watch_lists
    belongs_to :movies
end

class Movie 
	has_many :watch_list_movies
	has_many :users, through: :watch_list_movies
end
```
on Movie show page, we'll display how many users have added this to their watchlist (maybe also how many have actually seen it)
## What is the User Submittable attribute on the join model?
WatchListMovie has a watched attribute (boolean)
## What Validations do we need?
```
User 
	username, email presence: true
	username, email uniqueness: true
	has_secure_password

WatchList
    name, presence: true
    genre, presence: true

Movie
	title, presence: true
	release_year, presence: true
	mpaa_rating, presence: true

WatchListMovie
	watched, presence: true

```
## How do users fit into the application? How are they related to the other models?
User => WatchLists => Movies. A User has many WatchLists and has many Movies through each WatchList
## What are our Nested Routes? (We need a nested new route and either a nested index or nested show route)
WatchList#new '/watchlist/new'
WatchList#index '/watchlists'
WatchList#show '/watchlist/:watchlist_id'
WatchList#edit '/watchlist/edit'
WatchList#destroy '/watchlists'
WatchListMovies#index '/watchlist/:watchlist_id/movies'
WatcchListMovies#destroy '/watchlist/:watchlist_id/movies'
Movies#index '/movies'
Movies#show '/movies/:movie_id'

## Do we have Non Nested Versions of those nested routes?
## What Scope Method(s) do we have and how are they used?
scope(:watched) -> { where(watched: true) }
	def self.watched 
		where(watched: true)
	end
	def self.unwatched 
		where(watched: false) 
    end
the watched scope methods will be used to create a watched vs unwatched list
    def self.horror
        includes(:movies).where(genre: "horror")
    end
    def self.drama
        includes(:movies).where(genre: 'drama')
    end
    def self.action
        includes(:movies).where(genre: 'action')
    end
    def self.comedy
        includes(:movies).where(genre: 'comedy')
    end
    def self.scifi
        includes(:movies).where(genre: 'sci-fi')
    end
    def self.thriller
        includes(:movies).where(genre: 'thriller')
    end
    the genre scope methods will be used to place the movies in certain genres

## What does the schema for our app look like?
```rb
# table migration for: users 
# t.string :username
# t.string :email
# t.string :password_digest
class User
	# relationships
	has_many :watch_list_movies
	has_many :movies, through: :watch_list_movies
	# validations 
	username, email presence: true
	email uniqueness: true
	# scope_methods (if any)
end 

# table migration for: watch_lists
# t.string :name
# t.references :user
class WatchList
	# relationships
	belongs_to :user
    has_many :watch_list_movies
    has_many :movies, through: :watch_list_movies
    # validations
    has_many :watched_movies, -> { where(watch_list_movies: { watched: true }) }, through: :watch_list_movies, source: :movie
	has_many :unwatched_movies, -> { where(watch_list_movies: { watched: false}), through: :watch_list_movies, source: :movie 
	name, presence: true, uniqueness: true
	# user submittable attributes (if this is a join model)
	
	# scope_methods (if any)
	
end 
# table migration for: watch_list_movies 
# t.boolean :watched, default: false
# t.references :user
# t.references :movie
class WatchListMovie
	# relationships
	belongs_to :user
	belongs_to :movie
	# validations 
	watched, presence: true
	# user submittable attributes (if this is a join model)
	# watched
	# scope_methods (if any)
	scope(:watched) -> { where(watched: true) }
	def self.watched 
		where(watched: true)
	end
	def self.unwatched 
		where(watched: false) 
    end
    def self.genre_name(genres)
        includes(:movies).where(genre: genres)
    end
end 
# table migration for: movies 
# t.string :title
# t.integer :release_year
# t.string :mpaa_rating
# t.string :genre
class Movie 
	# relationships
	has_many :watch_list_movies
	has_many :watch_lists, through: :watch_list_movies
	# validations 
	title, presence: true
	description, presence: true
	release_year, presence: true
    mpaa_rating, presence: true
    genre, presence: true
	# user submittable attributes (if this is a join model)
	# scope_methods (if any)
end