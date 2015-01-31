class CollectionsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_ng_app

  def index
  end

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

  private

    def set_ng_app
      super 'collectionApp'
    end

end
