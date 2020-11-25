class MoviesController < ApplicationController

    def index

        @movies = Movie.all
        
    end

    def new     


    end

    def search

        @movie_ids = get_movie_id(params[:title])

        @movie = Movie.new

        
        unless @movie
            flash[:alert] = "Movie not found"
            return render :index
        end

    end

    

    def create
    
        @movie_info = find_movie(params[:movie][:imdb_id])
        @movie = Movie.new(title: @movie_info['title'], release_year: @movie_info["year"],
        mpaa_rating: @movie_info["rated"], description: @movie_info["description"], genre: @movie_info["genres"][0])

        if @movie.save
            redirect_to movies_path
        else
            render :search
        end

    end

    def show
        
        @movie = Movie.find(params[:id])

    end

    private

    def movie_params

        params.require(:movie).permit(:title, :description, :release_year, :mpaa_rating, :genre)

    end

    def get_movie_id(title)
        
        url = URI("https://movies-tvshows-data-imdb.p.rapidapi.com/?title=#{title}&type=get-movies-by-title")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

       

        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-key"] = ENV["RAPIDAPI_API_KEY"]
        request["x-rapidapi-host"] = 'movies-tvshows-data-imdb.p.rapidapi.com'

        response = http.request(request)
        JSON.parse(response.read_body) if response.is_a?(Net::HTTPSuccess) 
    

    end

    def find_movie(movie_id)

        url = URI("https://movies-tvshows-data-imdb.p.rapidapi.com/?imdb=#{movie_id}&type=get-movie-details")

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        
        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-key"] = ENV["RAPIDAPI_API_KEY"]
        request["x-rapidapi-host"] = 'movies-tvshows-data-imdb.p.rapidapi.com'

        response = http.request(request)
        
        JSON.parse(response.read_body) if response.is_a?(Net::HTTPSuccess) 
        
    end

end
