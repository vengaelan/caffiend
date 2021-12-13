class CreateMeetings < ActiveRecord::Migration[6.1]
  def change
    create_table :meetings do |t|
      t.string :invitee_email
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :location
      t.string :meeting_link
      t.string :status
      t.references :user

      t.timestamps
    end
  end
end
