class SessionPolicy < Struct.new(:user, :session)

  def initialize(user, session)
    raise Pundit::NotAuthorizedError, '您必须先登录才能进行此操作' unless user
    super
  end

  def destroy?
    true
  end

end