class DishesController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :list, :like]

  before_action :set_dish, only: [:show, :edit, :update, :destroy, :comments, :comment, :add_collection, :remove_collection, :like]
  before_filter :set_ng_app

  respond_to :html

  def index
    @dish   = Dish.new
    respond_with(@dishes)
  end

  def list
    @dishes = []

    if params[:user_id]
      @dishes = User.find(params[:user_id]).dishes
    else
      @dishes = Dish.order('created_at DESC').paginate(:page => params[:page], :per_page => 30)
    end

    render json: @dishes.map {|dish| dish.get_object(current_user)}
  end

  def comments
    render json: @dish.comment_threads.order('created_at').map {|c| c.get_object}
  end

  def comment
    @dish.comment_threads.create( body: params[:body], user_id: current_user.id)
    render json: {success: 'ok'}
  end

  def add_collection
    collection = Collection.find(params[:collection_id])
    if collection.user == current_user
      collection.dishes.push(@dish) if !collection.dishes.include?(@dish)
      render json: collection.get_object
    end
  end

  def remove_collection
    collection = Collection.find(params[:collection_id])
    if collection.user == current_user
      collection.dishes.delete(@dish) if collection.dishes.include?(@dish)
      render json: collection.get_object
    end
  end

  def show
    @cluster = shortest_first_of_ws_cluster
    respond_with(@dish)
  end

  def new
    @dish = Dish.new
    respond_with(@dish)
  end

  def like
    if @dish
      case params[:action_type]
      when 'like'
        if !current_user.voted_as_when_voted_for(@dish)
          @dish.class.transaction do
            @dish.liked_by(current_user)
          end
        end
      when 'dislike'
        if current_user.voted_as_when_voted_for(@dish)
          @dish.class.transaction do
            @dish.disliked_by(current_user)
          end
        end
      when 'state'
        # nothing to do
      end
      render json: {
        liked: current_user ? current_user.voted_as_when_voted_for(@dish) : nil,
        likes: @dish.get_likes.size
      }
    else
      render status: 403, nothing: true
    end
  end

  def edit
  end

  def create
    @dish = Dish.new(dish_params.merge(user_id: current_user.id))
    @dish.save
    render json: @dish.get_object(current_user)
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
