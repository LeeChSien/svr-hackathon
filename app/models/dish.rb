class Dish < ActiveRecord::Base
  belongs_to :user

  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_commentable
  acts_as_votable

  has_many :collect_dishes, :dependent => :destroy
  has_many :collection, :class_name => "Collection", :through => :collect_dishes, :source => :collection

  mount_uploader :photo, PhotoUploader

  def get_object
    attributes.merge({
      tag_view:  tag_view,
      tag_list:  tag_list,
      photo_url: photo.url,
      user:      user.get_object,
      comments_size: comment_threads.size
    })
  end

  def tag_view
    tag_list.map {|tag|
      %Q|<span class="label label-info">#{tag}</span>|
    }.join("\n");
  end

  after_create :create_essential

  def create_essential
    timestamp = Time.now
    update_attributes(fingerprint: Digest::MD5.hexdigest("dish-#{id}-#{timestamp}"))
  end
end
