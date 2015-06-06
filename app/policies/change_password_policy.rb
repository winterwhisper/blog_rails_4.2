class ChangePasswordPolicy < Struct.new(:user, :change_password)

  def initialize(user, change_password)
    raise Pundit::NotAuthorizedError, '您必须先登录才能进行此操作' unless user
    super
  end

  def create?
    true
  end

  def new?
    create?
  end

end