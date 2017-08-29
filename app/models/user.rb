# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_commit :assign_initial_credit, on: :create

  has_many :outgoing_transactions, class_name: 'Transaction',
    foreign_key: :sender_id
  has_many :incoming_transactions, class_name: 'Transaction',
    foreign_key: :recipient_id

  def num_credits
    # can be done in one query, though this is more legible
    # until performance becomes a concern
    incoming_transactions.sum(:num_credits) -
      outgoing_transactions.sum(:num_credits)
  end

  private

  def assign_initial_credit

  end
end
