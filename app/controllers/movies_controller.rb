class MoviesController < ApplicationController

    def index

        @movies = Movie.all

    end

    def show
        
        @movie = Movie.find(params[:id])

    end

    private

    def movie_params

        params.require(:movie).permit(:title, :description, :release_year, :mpaa_rating, :genre)

    end


end
