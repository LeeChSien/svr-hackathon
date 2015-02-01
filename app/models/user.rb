class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  has_many :dishes, :dependent => :destroy
  has_many :collections, :dependent => :destroy

  acts_as_voter

  mount_uploader :avatar, AvatarUploader

  def get_object
    {
      name: name,
      avatar_url: avatar_url,
      id: id
    }
  end

  def avatar_url(size=:thumb)
    if avatar.present?
      avatar.send(size).url
    else
      'http://res.cloudinary.com/kerjadulu/image/upload/v1403507399/no-user_cdkm3y.jpg'
    end
  end

  after_create :create_essential

  def create_essential
    timestamp = Time.now
    update_attributes(fingerprint: Digest::MD5.hexdigest("user-#{id}-#{timestamp}"))
  end
end
