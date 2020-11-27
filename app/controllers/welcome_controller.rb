class WelcomeController < ApplicationController
  def home
    @movies = Movie.all
  end
end
