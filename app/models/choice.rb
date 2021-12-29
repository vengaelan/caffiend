class Choice < ApplicationRecord
  belongs_to :meeting

  def time
    "#{start_datetime.strftime('%I:%M %p')} - #{end_datetime.strftime('%I:%M %p')}"
  end

  def start_time
    start_datetime.to_datetime
  end
end
