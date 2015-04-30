class PagesController < ApplicationController
  def home
    @posts = Post.all.order("created_at desc")
  end

  def game
  end
end
