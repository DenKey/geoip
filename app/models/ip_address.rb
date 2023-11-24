class IpAddress < ApplicationRecord
  validates :address, :ip_type, :coordinate, presence: true
  validates :address, uniqueness: true

  enum ip_type: {
    ipv4: 0,
    ipv6: 1
  }

  has_and_belongs_to_many :domains
end
