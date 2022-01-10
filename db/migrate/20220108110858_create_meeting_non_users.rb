class CreateMeetingNonUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :meeting_non_users do |t|

      t.references :meeting, foreign_key: true
      t.string :non_user_email

      t.timestamps
    end
  end
end
