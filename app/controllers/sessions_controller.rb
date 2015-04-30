class SessionsController < ApplicationController
	def new
	end

	def create
		user = User.authenticate(params[:handle], params[:password])

		if user
			session[:user_id] = user.id

			redirect_to root_url, :notice => "Logged in!"
		else
			redirect_to root_url, :notice => "Incorrect user information!"
		end
	end

	def destroy
		session[:user_id] = nil

		redirect_to root_url, :notice => "Logged out!"
	end
end
