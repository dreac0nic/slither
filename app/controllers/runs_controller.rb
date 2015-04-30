class RunsController < ApplicationController
	skip_before_action :verify_authenticity_token

	def index
		@runs = Run.all
	end

	def create

	end
end
