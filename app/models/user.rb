class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2] # Google Omniauth

  # References
  has_many :meeting_users, dependent: :destroy
  has_many :meetings, through: :meeting_users

  # Validations
  validates :first_name, :last_name, presence: true
  validates_format_of :first_name, :last_name, :with => /\A[^0-9`!@#\$%\^&*+_=]+\z/

  def self.from_omniauth(access_token)
    data = access_token
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
        image: data.info['image']
      )
      # Meeting.where(invitee_email: Meeting.pluck(:invitee_email).flatten).each do |m|
      #   mu = MeetingUser.new
      #   mu.user = user
      #   mu.meeting = m
      #   mu.save!
      # end
    end
    user
  end
end
