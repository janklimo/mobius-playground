# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'

  validates :num_credits, numericality: { greater_than_or_equal_to: 0 }

  scope :with_preloaded_users, -> { eager_load(:sender, :recipient) }
  scope :sorted, -> { order(created_at: :desc) }
end
