class CollectDish < ActiveRecord::Base
  belongs_to :collection
  belongs_to :dish
end
