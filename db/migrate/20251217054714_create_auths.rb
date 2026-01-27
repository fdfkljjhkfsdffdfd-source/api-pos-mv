class CreateAuths < ActiveRecord::Migration[7.0]
  def change
    create_table :auths do |t|
      t.string :login

      t.timestamps
    end
  end
end
