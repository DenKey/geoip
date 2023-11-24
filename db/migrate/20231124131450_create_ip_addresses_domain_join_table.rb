class CreateIpAddressesDomainJoinTable < ActiveRecord::Migration[7.1]
  def change
    create_table :domains_ip_addresses do |t|
      t.references :domain, foreign_key: true
      t.references :ip_address, foreign_key: true
    end
  end
end
