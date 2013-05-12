class CreateMessages < ActiveRecord::Migration
  def up
    create_table(:messages) do |t|
      t.string   :room
      t.string   :author
      t.text     :message
      t.datetime :at
      t.timestamps
    end
  end

  def down
    drop_table :messages
  end
end
