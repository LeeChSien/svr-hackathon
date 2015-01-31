class CollectionsController < ApplicationController
  before_filter :authenticate_user!

  def create
    collection = Collection.new(name: params[:name])
    collection.user = current_user
    collection.save

    render json: collection.get_object
  end

  def destroy
    collection = Collection.find(params[:id])
    collection.destroy

    render json: {success: true}
  end

end
