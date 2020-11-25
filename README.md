# README

## Getting Started..

### Usinng Devise in your project to set up user authentication with mailer options..

Begin by adding the gem

```rb
bundle add devise
```
Run generator to install

```rb
rails g devise:install
```
Configure Action Mailer URL options

```rb
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```
Set up Root route

```rb
rails g controller welcome home
```
in your config/routes.rb file

```rb
root 'welcome#home'
```
Create home page content

Make sure you have set up devise properties set up in User model

```rb
 devise :database_authenticatable, :registerable, :recoverable,
         :validatable,
```

Add flash messages for errors through devise in your application file of your /views/layout folder

```rb
<body>
    <p class="notice"><%= notice %></p>
    <p class="alert"><%= alert %></p>
    <%= yield %>
</body>

```
### Implementing Facebook Oauth as optional login for application

Install gems

```rb
bundle add omniauth
bundle add omniauth-facebook
bundle add dotenv-rails
```

Configure environment variables

```rb

config.omniauth :facebook,ENV["FACEBOOK_CLIENT"], ENV["FACEBOOK_SECRET"]

```

Use this address to create a Client ID and Secret for your app

https://developers.facebook.com/docs/authentication/

Check this address for how to go through the process once you get to the facebook developer site

https://stackoverflow.com/questions/32538847/how-to-setup-facebook-app-for-localhost

Create .env file and insert Client ID and Secret that you recieved from the facebook developer site

```rb
FACEBOOK_SECRET= 'client_secret goes here'
FACEBOOK_CLIENT= 'client_id goes here'
```

Add .env file to the .gitignore file to make sure that your client ID and secret are not visible to the public

Set up a link in your devise/shared/_links.html.erb file

```rb
<%- if devise_mapping.omniauthable? %>
  <%- resource_class.omniauth_providers.each do |provider| %>
    <%= link_to omniauth_authorize_path(resource_name, provider) do %>
      <%= image_tag("fb.png", width: "150px") %>
    <% end %>
  <% end %>
<% end %>

```
Add attributes in your User migration table 

```rb

rails g migration AddColumnToUser name email image:text uid provider

```

Include these class methods into your User model

```rb

def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end

  ```

### Using Movie Database API

Once you have found the API you want to use input the code from their API into class methods within the Movies
Controller and add the API key to your .env file

## What is the Many to many relationship and how is it used?

WatchList <=> Movies
WatchListMoives <=> Movies
WatchList <=> WatchListMovies
```rb
class User
	has_many :watch_lists
	has_many :watch_list_movies
	has_many :movies, through: :watch_lists
end 

class WatchList
	belongs_to :user
    has_many :watch_list_movies
	has_many :movies, through: :watch_list_movies
	has_many :watched_movies, -> { where(watch_list_movies: {watched: true}) },
  	through: :watch_list_movies, source: :movie
  	has_many :unwatched_movies, -> { where(watch_list_movies: {watched: false}) },
  	through: :watch_list_movies, source: :movie    
end

class WatchListMovie
    belongs_to :watch_list
    belongs_to :movie
end

class Movie 
	has_many :watch_list_movies
	has_many :watch_lists, through: :watch_list_movies
end
```
on Movie show page, we'll display how many users have added this to their watchlist (maybe also how many have actually seen it)

## What is the User Submittable attribute on the join model?

WatchListMovie has a watched attribute (boolean)

## What Validations do we need?
```
User 
	through devise, an authentication was setup to 
	make sure an email and password was present and unique

WatchList
    name, presence: true, uniqueness: true

Movie
	title, presence: true, uniqueness: {scope: :release_year}
	release_year, presence: true
	mpaa_rating, presence: true
	:description, presence: true
	:genre, presence: true

WatchListMovie
	watched, inclusion: [true, false]

```
## How do users fit into the application? How are they related to the other models?

User => WatchLists => WatchListMoives => Movies. A User has many WatchLists and a WatchList has many WatchListMovies. WatchListw have many Movies through each WatchListMovie

## What are our Nested Routes? (We need a nested new route and either a nested index or nested show route)

WatchListMovies#new '/watchlist/watchlist_id/watch_list_movies/new'
WatchListMovies#index '/watchlist/:watchlist_id/watch_list_movies'


## Do we have Non Nested Versions of those nested routes?

WatchList#new '/watchlist/new'
WatchList#index '/watchlists'
WatchList#show '/watchlist/:watchlist_id'
WatchList#edit '/watchlist/edit'
WatchList#destroy '/watchlists'
Movies#index '/movies'
Movies#show '/movies/:movie_id'
Movies#new '/movies/new'
Movies#search '/search'

## What Scope Method(s) do we have and how are they used?

scope(:watched) -> { where(watched: true) }
	
scope :unwatched, -> { where(watched: false) }

the watched scope methods will be used to create a watched vs unwatched list

## What does the schema for our app look like?
```rb
# table migration for: users 
# t.string :username
# t.string :email
# t.string :encrypted_password
#t.string :full_name
#t.string :uid
#t.string :avatar_url
#t.string :name
#t.string :image
#t.string :provider
class User
	# relationships
	has_many :watch_lists
	has_many :watch_list_movies
	has_many :movies, through: :watch_list_movies
	# validations 
	devise :database_authenticatable, :registerable, :recoverable,
    :validatable, :omniauthable, omniauth_providers: [ :facebook]
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
    has_many :watched_movies, -> { where(watch_list_movies: { watched: true }) }, through: :watch_list_movies, source: :movie
	has_many :unwatched_movies, -> { where(watch_list_movies: { watched: false}), through: :watch_list_movies, source: :movie 
	# validations
	name, presence: true, uniqueness: true
	# user submittable attributes (if this is a join model)
	
	# scope_methods (if any)
	
end 
# table migration for: watch_list_movies 
# t.boolean :watched, default: false
# t.references :watch_list
# t.references :movie
class WatchListMovie
	# relationships
	belongs_to :watch_list
	belongs_to :movie
	# validations 
	watched, presence: true
	# user submittable attributes (if this is a join model)
	# watched
	# scope_methods (if any)
	scope :watched -> { where(watched: true) }
	scope :unwatched, -> { where(watched: false) }
end 
# table migration for: movies 
# t.string :title
# t.integer :release_year
# t.string :mpaa_rating
# t.string :genre
# t.text :description
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
	def self.genre_name(genres)
        includes(:movies).where(genre: genres)
    end
end