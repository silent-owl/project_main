class ApplicationController < ActionController::Base
	 protect_from_forgery with: :exception
	 #узнать нахуя эта строчка ^^^^^^^^^^ !!!
	 # root 'controller_Name#action'
end
