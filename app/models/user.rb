class User < ActiveRecord::Base
  authenticates_with_sorcery!

  include Roleable::Subject

  attr_accessible :password_confirmation,
                  :username, :email,
                  :password

  validates_confirmation_of :password
  validates_presence_of     :password, on: :create
  validates_presence_of     :email
  validates_uniqueness_of   :username
  validates_uniqueness_of   :email

  def is? role, instance = nil
    self.has_role? role, instance
  end

  def as_json
    { name: self.username }
  end

end
