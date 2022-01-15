class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2] # Google Omniauth

  # References
  has_many :meeting_users, dependent: :destroy
  has_many :meetings, through: :meeting_users
  has_one_attached :photo

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
      MeetingNonUser.where(non_user_email: user.email).each do |meeting_non_user|
        meeting = meeting_non_user.meeting
        mu = MeetingUser.new
        mu.meeting = meeting
        mu.user = user
        mu.save!
        meeting_non_user.destroy!
      end

      # Meeting.where(invitee_email: Meeting.pluck(:invitee_email).flatten).each do |m|
      #   mu = MeetingUser.new
      #   mu.user = user
      #   mu.meeting = m
      #   mu.save!
      # end
    end
    user
  end

  # For dashboard "New Connections Made, add .length after method"
  def self.connections(user)
    connections = {}
    user.meetings.each do |meeting|
      meeting.invitee_email.each do |email|
        connections.include?(email) ? connections[email] += 1 : connections[email] = 1
      end
    end
    connections
  end

  # For dashboard "Completed Coffee Chats"
  def self.completed_meetings(user)
    user.meetings.where("status = ? AND end_datetime < ?", "ACCEPTED", Date.today).length
  end

  # For dashboard "Recurring Chats"
  def self.recurring_chats(user)
    User.connections(user).select { |_k, v| v > 1 }.length
  end

  # For first three meetings
  def self.first_three_meetings(user)
    user.meetings.where("start_datetime > ?", Date.today).order(:start_datetime)[...3]
  end
end
