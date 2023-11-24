class CreateIpAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :ip_addresses do |t|
      t.inet :address, null: false, index: { unique: true }
      t.integer :ip_type, null: false
      t.point :coordinate, null: false

      t.timestamps
    end

    add_index :ip_addresses, :coordinate, using: :gist
  end
end
