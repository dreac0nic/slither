class UsersController < ApplicationController
	def new
		@user = User.new
	end

	def create
		@user = User.new user_params

		redirect_to root_url, :notice => "I swear it worked. ;)"

		#if @user.save
		#	redirect_to root_url, :notice => "Account created successfully! Welcome!"
		#else
		#	render "new"
		#end
	end

	private

	def user_params
		params.require(:user).permit(:handle, :email, :password, :password_confirmation)
	end
end
