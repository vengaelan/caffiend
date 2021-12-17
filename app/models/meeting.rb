class Meeting < ApplicationRecord
  # References
  belongs_to :user

  # Validations
  validates :start_datetime, :end_datetime, presence: true
  validates_format_of :invitee_email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => true
  attribute :status, :string, default: 'PENDING'
  validates :status, inclusion: { in: ["PENDING", "ACCEPTED", "CANCELLED", "COMPLETED"] }

  # Simple Calender
    default_scope -> { order(:start_datetime) }  # Our meetings will be ordered by their start_time by default

    def time
      "#{start_datetime.strftime('%I:%M %p')} - #{end_datetime.strftime('%I:%M %p')}"
    end

    def start_time
      start_datetime.to_datetime
    end
end