class PostsController < ApplicationController
	before_filter :user_signed_in?, :only => [:new, :create, :destroy]

	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id

		if @post.save
			redirect_to posts_url, notice: "Post successfully created!"
		else
			render :new
		end
	end

	def show
		@post = Post.find(params[:id])
	end

	private

	def post_params
		params.require(:post).permit(:user_id, :body)
	end

	def user_signed_in?
		if current_user
			@user = current_user
		else
			redirect_to root_url, :notice => "You must be signed in to use that!"
		end
	end

	def user_owns_post?(post)
		current_user && post.user_id == current_user.id
	end
end
