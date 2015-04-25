class User < ActiveRecord::Base
	has_many :articles

	validates :handle, presence: true,
	                     length: { minimum: 6 }
	validates :password, presence: true,
	                       length: { minimum: 8 }
	validates :email, presence: true
end
