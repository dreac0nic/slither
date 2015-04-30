class PagesController < ApplicationController
  def home
  end

  def game
    @new_run = Run.new
  end
end
