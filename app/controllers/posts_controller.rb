class PostsController < ApplicationController
  def show
    @parser = MarkdownParser.instance
    @post = Post.find(params[:id])
  end
end
