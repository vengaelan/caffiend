class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  # References
  has_many :meetings

  # Validations
  validates :first_name, :last_name, presence: true
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

  def self.from_omniauth(access_token)
    data = access_token
    # data_cred = access_token.credentials
    user = User.where(email: data.info['email']).first

    # For creation of user with data from google
    unless user
      user = User.create(
        first_name: data.info['first_name'],
        last_name: data.info['last_name'],
        email: data.info['email'],
        password: Devise.friendly_token[0, 20],
        provider: data.provider,
        uid: data.uid,
        token: data.credentials.token,
        expires: data.credentials.expires,
        expires_at: data.credentials.expires_at,
        refresh_token: data.credentials.refresh_token
      )
    end
    user
  end
end
