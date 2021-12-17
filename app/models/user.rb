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
    data = access_token.info
    user = User.where(email: data['email']).first

    # For creation of user with data from google
    unless user
        user = User.create(first_name: data['first_name'],
          last_name: data['last_name'],
          email: data['email'],
          password: Devise.friendly_token[0,20]
        )
    end
    user
  end
end
