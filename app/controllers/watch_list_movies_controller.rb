class WatchListMoviesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_watch_list

    def index

        @watch_list_movies = @watch_list.watch_list_movies
    
        if params[:genre].present? 
            @movies = Movie.genre_name(params[:genre])
            @watch_list_movies = @watch_list_movies.where(movie_id: @movies.pluck(:id))
        end

    end


    def new

        @watch_list_movie = @watch_list.watch_list_movies.new
        
    end

    def create
        
        @watch_list_movie = @watch_list.watch_list_movies.new(watch_list_movie_params)

        
        if @watch_list_movie.save
            redirect_to watch_list_watch_list_movies_path(@watch_list_movie.watch_list)
        else
            render :new
        end

    end

    def edit

    end

    def update

        @watch_list_movie = @watch_list.watch_list_movies.find(params[:id])
        

        if @watch_list_movie.update(update_watch_list_movie_params)
            redirect_to watch_list_path(@watch_list)
        else
            render :edit
        end

    end



    private

    def watch_list_movie_params
    
        params.require(:watch_list_movie).permit(:watch_list_id, :movie_id)

    end

    def update_watch_list_movie_params
        params.require(:watch_list_movie).permit(:watched)
    end

    def set_watch_list

        @watch_list = current_user.watch_lists.find(params[:watch_list_id])

    end

end
