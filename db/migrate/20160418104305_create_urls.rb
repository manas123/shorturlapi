class CreateUrls < ActiveRecord::Migration
  def change
    create_table :shorturls do |t|
      t.string :longurl
      t.string :shorturlkey
      t.string :shorturl
      t.datetime :expires_at

      t.timestamps null: false
    end
  end
end
