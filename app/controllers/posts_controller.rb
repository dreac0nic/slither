class PostsController < ApplicationController
	before_filter :user_signed_in?, :only => [:new, :create, :destroy]

	def index
		redirect_to root_url
	end

	def new
		redirect_to root_url
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id

		if @post.save
			redirect_to root_url
		else
			redirect_to root_url, notice: "Could not save post!"
		end
	end

	def show
		redirect_to root_url
	end

	def edit
		redirect_to root_url
	end

	def update
		redirect_to root_url
	end

	def destroy
		redirect_to root_url
	end

	private

	def post_params
		params.require(:post).permit(:user_id, :body)
	end

	def user_signed_in?
		if current_user
			@user = current_user
		else
			redirect_to root_url, notice: "You must be signed in to use that!"
		end
	end

	def user_owns_post?(post)
		current_user && post.user_id == current_user.id
	end
end
