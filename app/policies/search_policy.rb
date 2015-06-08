class SearchPolicy < Struct.new(:user, :search)

  def initialize(user, dashboard)
    raise Pundit::NotAuthorizedError, '您必须先登录才能进行此操作' unless user
    super
  end

  def show?
    true
  end

end