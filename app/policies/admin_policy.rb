class AdminPolicy < ApplicationPolicy

  def show?
    true
  end

  class Scope < Scope
  end
end
