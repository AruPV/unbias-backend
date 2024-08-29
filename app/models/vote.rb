class Vote < ApplicationRecord
  belongs_to :article
  belongs_to :user
  validates :user_id, presence: true
  validates :is_like, inclusion: [true, false]
end
