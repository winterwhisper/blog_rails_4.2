class Admin::Session

  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :name, :password, :admin, :remember_me

  validates_presence_of :name, :password

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
      if _admin = Admin.find_by_name(name)
        if _admin.authenticate(password)
          self.admin = _admin
          if remember_me

          end
          true
        else
          self.errors.add(:password, '密码错误')
          false
        end
      else
        self.errors.add(:name, '用户名错误')
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