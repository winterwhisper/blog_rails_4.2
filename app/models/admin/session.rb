class Admin::Session

  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :password, :user, :remember_me

  validates_presence_of :name, :password

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      if _user = User.find_by_name(name)
        if _user.authenticate(password)
          self.user = _user
        else
          self.errors.add(:password, 'invalid password.')
          false
        end
      else
        self.errors.add(:name, 'invalid name.')
        false
      end
    end
  end

  def persisted?
    false
  end

  private

    def attributes=(attributes)
      attributes = attributes.symbolize_keys
      (attributes.keys & [:name, :password]).each do |v|
        send(:"#{v}=", attributes[v].to_s)
      end
    end

end