class SessionPolicy < Struct.new(:user, :session)

  def create?
    raise Pundit::NotAuthorizedError, '您已登录' if user
    true
  end

  def new?
    create?
  end

  def destroy?
    raise Pundit::NotAuthorizedError, '您必须先登录才能进行此操作' unless user
    true
  end

end