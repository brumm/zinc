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

  def is? role, instance_or_class = nil
    if instance_or_class.respond_to? :id
      self.has_role? role, instance_or_class
    else
      (resources_with_role role, instance_or_class).any?
    end
  end

  def roles resource = nil
    return [] if self.new_record?

    global_roles = self.roles_for_resource(nil).map(&:name)
    resource_roles = self.roles_for_resource(resource).map(&:name)

    (global_roles + resource_roles).uniq
  end

  def as_json options = {}
    {
      id: self.id,
      name: self.username,
      roles: self.roles(options[:resource])
    }
  end

end
