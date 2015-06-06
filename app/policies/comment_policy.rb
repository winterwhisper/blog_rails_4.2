class CommentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.order('id DESC')
    end
  end
end
