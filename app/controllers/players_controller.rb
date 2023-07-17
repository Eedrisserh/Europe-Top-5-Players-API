class PlayersController < ApplicationController
    before_action :authenticate_user, only: [:create, :update, :destroy]
  
    def index
      players_cache_key = 'players'
      players = Rails.cache.fetch(players_cache_key, expires_in: 1.hour) do
        players_data = Player.select(:id, :name, :age, :nationality, :place_of_birth, :position,
                                    :shirt_no, :foot, :club, :agent, :league)
                             .page(params[:page]).per(20)
        players_data.as_json
      end
      render json: {
        "Europe's Top 5 League Players 2021/2022": players,
      }
    end
    
  
    def show
      @player = Rails.cache.fetch(player_cache_key(params[:id]), expires_in: 1.hour) do
        Player.find(params[:id])
      end
      render json: @player
    end
  
    def create
      @player = Player.new(player_params)
      if @player.save
        # Clear the cache when a new player is created
        Rails.cache.delete(players_cache_key)
        render json: @player, status: :created
      else
        render json: @player.errors, status: :unprocessable_entity
      end
    end

  
    def update
      @player = Player.find(params[:id])
  
      if @player.update(player_params)
        Rails.cache.delete(player_cache_key(params[:id]))
        Rails.cache.delete(players_cache_key)
        render json: @player, status: :ok
      else
        render json: @player.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @player = Player.find(params[:id])
      @player.destroy
      Rails.cache.delete(player_cache_key(params[:id]))
      Rails.cache.delete(players_cache_key)
      # render json: @player, status: :ok
      head :no_content
    end
  
    private
  
    def player_params
      params.require(:player).permit(:name, :age, :nationality, :place_of_birth, :position,
                                     :shirt_no, :foot, :club, :agent, :league)
    end
  
    def authenticate_user
      unless current_user
        render json: { error: "You must be logged in to perform this action" }, status: 401
      end
    end
  
    def player_cache_key(player_id)
      "player/#{player_id}"
    end
  end


# class PlayersController < ApplicationController
#     before_action :authenticate_user, only: [:create, :show, :update, :destroy]
  
#     def index
#         players = Player.select(:name, :age, :nationality, :place_of_birth, :position,
#                                      :shirt_no, :foot, :club, :agent, :league)
#                         .page(params[:page]).per(20)
#         render json: {
#           "Europe's Top 5 League Players 2021/2022": players,
#           pagination: {
#             current_page: players.current_page,
#             total_pages: players.total_pages,
#             total_count: players.total_count
#           }
#         }
#     end

#     def show
#     @player = Rails.cache.fetch(player_cache_key(params[:id]), expires_in: 1.hour) do
#         Player.find(params[:id])
#     end
#     render json: @player
#     end

#     def create
#       @player = Player.new(player_params)
#       if @player.save
#         render json: @player
#       else
#         render json: @player.errors, status: :unprocessable_entity
#       end
#     end
  
#     def update
#         @player = Player.find(params[:id])
      
#         if @player.update(player_params)
#           expire_action(action: :show, id: params[:id])
#           render json: @player, status: :ok
#         else
#           render json: @player.errors, status: :unprocessable_entity
#         end
#     end    
  
#     def destroy
#         @player = Player.find(params[:id])
#         @player.destroy
#         expire_action(action: :show, id: params[:id])
#     end
  
#     private
  
#     def player_params
#       params.require(:player).permit(:name, :age, :nationality, :place_of_birth, :position,
#                                      :shirt_no, :foot, :club, :agent, :league)
#     end
  
#     def authenticate_user
#         unless current_user
#           respond_to do |format|
#             format.html { redirect_to new_user_session_path }
#             format.json { render json: { error: "You must be logged in to perform this action" }, status: 401 }
#           end
#         end
#     end
  
#     def player_cache_key(player_id)
#       "player/#{player_id}"
#     end
# end
  