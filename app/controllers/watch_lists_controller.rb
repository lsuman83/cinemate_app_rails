class WatchListsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_watch_list, only: [:show, :edit, :update, :destroy]
    def index
        @watch_lists = current_user.watch_lists
    end

    def show
        
    end

    def new
        @watch_list = WatchList.new
    end

    def create
        @watch_list = current_user.watch_lists.build(watch_list_params)

        if @watch_list.save
            redirect_to watch_list_path(@watch_list)
        else
            render :new
        end

    end

    def edit

    end

    def update

        if @watch_list.update(watch_list_params)
            redirect_to watch_list_path(@watch_list)
        else
            render :edit
        end

    end

    def destroy
        @watch_list.destroy
        redirect_to watch_lists_path
    end

    private
    
    def set_watch_list
        @watch_list = current_user.watch_lists.find(params[:id])
    end

    def watch_list_params
        params.require(:watch_list).permit(:name)
    end

end
