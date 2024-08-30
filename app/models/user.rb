class User < ApplicationRecord
  has_many :articles
  has_many :votes, dependent: :destroy
  validates :clerk_id, presence: true, uniqueness: true
end
