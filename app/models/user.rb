class User < ActiveRecord::Base
	attr_accessor :password

	before_save :encrypt_password

	validates_presence_of :handle
	validates_uniqueness_of :handle
	validates_presence_of :password, :on => :create
	validates_confirmation_of :password
	validates_presence_of :email
	validates_uniqueness_of :email

	has_many :posts

	def avatar_url
		"http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.downcase.strip)}"
	end

	def self.authenticate(handle, password)
		user = find_by_handle(handle)

		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			user
		else
			nil
		end
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt);
		end
	end
end
