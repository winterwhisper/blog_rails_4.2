class Admin::ChangePassword

  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :old_password, :password, :password_confirmation

  validates_presence_of :old_password, :password, :password_confirmation

  def initialize(params = {})
    self.attributes = params
  end

  def save
    if valid?
    end
  end

  def persisted?
    false
  end

  private

  def attributes=(attributes)
    attributes = attributes.symbolize_keys
    (attributes.keys & [:old_password, :password]).each do |v|
      send(:"#{v}=", attributes[v].to_s)
    end
  end

end