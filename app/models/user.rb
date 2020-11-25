class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :watch_lists
  has_many :watch_list_movies
  has_many :movies, through: :watch_list_movies

  devise :database_authenticatable, :registerable, :recoverable,
         :validatable, :omniauthable, omniauth_providers: [ :facebook]

  
  def self.from_google(uid:, email:, full_name:, avatar_url:)
    if user = User.find_by(email: email)
      user.update(uid: uid, full_name: full_name, avatar_url: avatar_url) unless user.uid.present?
      user
    else
      User.create(
        email: email,
        uid: uid,
        full_name: full_name,
        avatar_url: avatar_url,
        password: SecureRandom.hex
        )
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name   # assuming the user model has a name
      user.image = auth.info.image # assuming the user model has an image
    end
  end
  
end
