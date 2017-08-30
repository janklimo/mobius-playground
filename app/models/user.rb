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

  scope :admins, -> { where(is_admin: true) }
  scope :regular, -> { where(is_admin: false) }

  def num_credits
    # can be done in one query, though this is more legible
    # until performance becomes a concern
    incoming_transactions.sum(:num_credits) -
      outgoing_transactions.sum(:num_credits)
  end

  def can_send?(amount)
    num_credits >= amount.to_f
  end

  def all_transactions
    Transaction.where(sender: self).or(Transaction.where(recipient: self))
  end

  private

  # create an admin account unless it exists already
  def assign_initial_credit
    admin = User.admins.last ||
      User.create(
        email: 'hello@mobius.network',
        is_admin: true,
        password: rand(36**11).to_s(36).upcase[0, 8]
      )

    Transaction.create(sender: admin, recipient: self, num_credits: 100)
  end
end
