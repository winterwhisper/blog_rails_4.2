class Admin::BaseController < ApplicationController

  layout 'admin'

  before_action :set_tags

  private

    def set_tags
      @tags = Tag.all
    end

end