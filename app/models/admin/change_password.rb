class Admin::ChangePassword

  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :admin, :old_password, :password, :password_confirmation

  validates_presence_of :old_password, :password, :password_confirmation
  validates_confirmation_of :password

  def initialize(admin, params = {})
    self.admin = admin
    self.attributes = params
  end

  def save
    if valid?
      if admin.authenticate(old_password)
        admin.password = password
        admin.save
        true
      else
        self.errors.add(:old_password, '旧密码输入错误')
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
    (attributes.keys & [:old_password, :password, :password_confirmation]).each do |v|
      send(:"#{v}=", attributes[v].to_s)
    end
  end

end