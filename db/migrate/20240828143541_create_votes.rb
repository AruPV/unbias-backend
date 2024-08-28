class CreateVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :votes do |t|
      t.references :article_version, null: false, foreign_key: true
      t.boolean :is_like
      t.string :user_id_clerk

      t.timestamps
    end
  end
end
