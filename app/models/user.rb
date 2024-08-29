class User < ApplicationRecord
  has_many :articles
  has_many :votes, dependent: :destroy
end
