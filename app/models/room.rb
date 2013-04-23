class Room < ActiveRecord::Base
  attr_accessible :title, :slug

  include FriendlyId
  friendly_id :slug

  include Roleable::Resource

  validates :title, :uniqueness => true
  validates :slug,  :uniqueness => true, :format => /\A[a-z-]+\z/
end
