class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :watch_list_movies
  has_many :movies, through: :watch_list_movies
  
  devise :database_authenticatable, :registerable,
         :validatable
end
