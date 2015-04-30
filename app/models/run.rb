class Run < ActiveRecord::Base
	belongs_to :user

	def duration
		if start_on && finished_on
			Time.diff(start_on, finished_on, "%m:%s")
		else
			{:diff => "N/A"}
		end
	end
end
