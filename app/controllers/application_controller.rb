class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

  

  def record_not_found
    flash[:message] = "Not Found"
    redirect_to root_path
  end

  def search

    @movie_ids = get_movie_id(params[:title])

        @movie = Movie.new

        
        unless @movie
            flash[:alert] = "Movie not found"
            return render :index
        end

  end
  

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
