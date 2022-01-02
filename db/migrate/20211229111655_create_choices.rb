class CreateChoices < ActiveRecord::Migration[6.1]
  def change
    create_table :choices do |t|
      t.datetime :start_datetime
      t.datetime :end_datetime
      t.string :location
      t.references :meeting

      t.timestamps
    end
  end
end
