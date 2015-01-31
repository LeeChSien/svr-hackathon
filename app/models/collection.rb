class Collection < ActiveRecord::Base
  belongs_to :user

  has_many :collect_dishes, :dependent => :destroy
  has_many :dishes, :class_name => "Dish", :through => :collect_dishes, :source => :dish

  def get_object
    attributes.merge({dishes: dishes.map {|d| d.get_object}})
  end
end
