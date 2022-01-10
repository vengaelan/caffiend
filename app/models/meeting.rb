class Meeting < ApplicationRecord
  # References
  has_many :meeting_users, dependent: :destroy
  has_many :meeting_non_users, dependent: :destroy
  has_many :users, through: :meeting_users
  has_many :choices, dependent: :destroy
  accepts_nested_attributes_for :choices, reject_if: :all_blank, allow_destroy: true

  # Validations
  serialize :invitee_email, Array
  validates :start_datetime, :end_datetime, presence: true, :if => :invitee_email?
  validates_format_of :invitee_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
  attribute :status, :string, default: 'PENDING'
  validates :status, inclusion: { in: ["PENDING", "ACCEPTED", "CANCELLED", "COMPLETED"] }

  # Simple Calender
    # default_scope -> { order(:start_datetime) }  # Our meetings will be ordered by their start_time by default

    def time
      "#{start_datetime.strftime('%I:%M %p')} - #{end_datetime.strftime('%I:%M %p')}"
    end

    def start_time
      start_datetime.to_datetime
    end
end
