class RunsController < ApplicationController
	skip_before_action :verify_authenticity_token
	before_filter :redirect_to_root, :only => [:index, :new, :edit, :update, :destroy]

	def index
		@runs = Run.all
	end

	def new
	end

	def create
		@run = Run.new(run_params)
		@run.user_id = current_user.id
		@run.start_on = Time.at(params[:run][:started_on_ms].to_f/1000).to_formatted_s(:sql)
		@run.finished_on = Time.at(params[:run][:finished_on_ms].to_f/1000).to_formatted_s(:sql)

		@run.save

		render nothing: true
	end

	def edit
	end

	def update
	end

	def destroy
	end

	private

	def run_params
		params.require(:run).permit(:score, :dots, :completed)
	end

	def redirect_to_root
		redirect_to root_url
	end
end
