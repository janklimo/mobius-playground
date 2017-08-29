require 'rails_helper'

describe Transaction do
  describe 'validations' do
    it 'validates that credits are a positive value' do
      transaction = build_stubbed(:transaction)

      transaction.num_credits = -10
      expect(transaction).not_to be_valid

      transaction.num_credits = 'nope'
      expect(transaction).not_to be_valid

      transaction.num_credits = 2.3
      expect(transaction).to be_valid
    end
  end
end

