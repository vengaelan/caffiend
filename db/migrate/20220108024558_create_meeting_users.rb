class CreateMeetingUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :meeting_users do |t|

      t.references :user, foreign_key: true
      t.references :meeting, foreign_key: true
      t.boolean :host, default: false

      t.timestamps
    end
  end
end
