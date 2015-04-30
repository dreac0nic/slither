class PagesController < ApplicationController
  def home
    @new_post = Post.new
    @posts = Post.all.order("created_at desc")
    @highscores = Run.all.order("score desc")
  end

  def game
  end
end
