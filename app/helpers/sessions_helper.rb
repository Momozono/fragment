module SessionsHelper
	def sign_in(user)
		remember_token = User.new_remember_token
		cookies.permanent[:remember_token] = remember_token #cookieに記憶トークンを格納
		user.update_attribute(:remember_token, User.encrypt(remember_token)) #Userモデルに記憶トークンを格納
		self.current_user = user #current_user属性に
	end

	def signed_in?
		!current_user.nil?
	end
	def current_user=(user)
		@current_user = user
	end
	def current_user
		remember_token = User.encrypt(cookies[:remember_token]) #クッキーに格納された記憶トークンを暗号化
		@current_user ||= User.find_by(remember_token: remember_token) #Userモデルから記憶トークンをもとに検索
	end

	def current_user?(user)
		user == current_user
	end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url
	end
end