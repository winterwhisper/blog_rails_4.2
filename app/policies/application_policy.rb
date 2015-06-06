class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, '您必须先登录才能进行此操作' unless user
    @user = user
    @record = record
  end

  # def index?
  #   true
  # end

  # def show?
  #   scope.where(:id => record.id).exists?
  # end

  def create?
    true
  end

  def new?
    create?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    true
  end

  # def scope
  #   Pundit.policy_scope!(user, record.class)
  # end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      raise Pundit::NotAuthorizedError, '您必须先登录才能进行此操作' unless user
      @user = user
      @scope = scope
    end

    def resolve
      scope.order('id DESC')
    end
  end
end
