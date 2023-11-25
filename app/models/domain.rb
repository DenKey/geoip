class Domain < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_and_belongs_to_many :ip_addresses, dependent: :destroy
end
