class CreateOAuths < ActiveRecord::Migration[7.0]
  def change
    create_table :o_auths do |t|
      t.text :code_verifier, null: false
      t.text :code_challenge, null: false
      t.text :refresh_token
      t.text :access_token
      t.datetime :expires_at
      t.boolean :expired
      t.text :state, null: false
      t.timestamps
    end
  end
end
