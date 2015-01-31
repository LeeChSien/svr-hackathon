class DishesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :list]

  before_action :set_dish, only: [:show, :edit, :update, :destroy, :comments, :comment]
  before_filter :set_ng_app

  respond_to :html

  def index
    @dish   = Dish.new
    respond_with(@dishes)
  end

  def list
    @dishes = Dish.all
    render json: @dishes.map {|dish| dish.get_object}
  end

  def comments
    render json: @dish.comment_threads.map {|c| c.get_object}
  end

  def comment
    @dish.comment_threads.create( body: params[:body], user_id: current_user.id)
    render json: {success: 'ok'}
  end

  def show
    @cluster = shortest_first_of_ws_cluster
    respond_with(@dish)
  end

  def new
    @dish = Dish.new
    respond_with(@dish)
  end

  def edit
  end

  def create
    @dish = Dish.new(dish_params.merge(user_id: current_user.id))
    @dish.save
    respond_with(@dish)
  end

  def update
    @dish.update(dish_params)
    respond_with(@dish)
  end

  def destroy
    @dish.destroy
    respond_with(@dish)
  end

  private
    def set_dish
      @dish = Dish.find(params[:id])
    end

    def dish_params
      params.require(:dish).permit(:store_name, :photo, :description, :latitude, :longitude, :user_id, :tag_list)
    end

    def set_ng_app
      super 'dishApp'
    end
end
