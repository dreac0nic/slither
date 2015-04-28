class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new user_params

		if @user.save
			redirect_to root_url, :notice => "Account created successfully! Welcome!"
		else
			render "new"
		end
	end

	def show
		@user = User.find_by handle: params[:handle]

		redirect_to root_url, :notice => "That user does not exist!" if not @user
	end

	private

	def user_params
		params.require(:user).permit(:handle, :email, :password, :password_confirmation)
	end
end
