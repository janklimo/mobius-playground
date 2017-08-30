require 'rails_helper'

describe User do
  describe 'callbacks' do
    it 'creates a new transaction for new users' do
      user = create(:user)
      expect(user.num_credits).to eq 100
      expect(user.incoming_transactions.size).to eq 1
      expect(user.outgoing_transactions.size).to eq 0
      expect(user.incoming_transactions.last.sender.email)
        .to eq 'hello@mobius.network'
    end
  end

  context 'transactions' do
    before do
      @user = create(:user)

      # noise
      create_list(:transaction, 5, num_credits: rand(42))

      # incoming
      @incoming1 = create(:transaction, recipient: @user, num_credits: 1000)
      @incoming2 = create(:transaction, recipient: @user, num_credits: 50)

      # outgoing
      @outgoing1 = create(:transaction, sender: @user, num_credits: 40)
      @outgoing2 = create(:transaction, sender: @user, num_credits: 900)
    end

    describe 'incoming transactions' do
      it 'returns the right collection' do
        # initial credit
        expect(@user.incoming_transactions.count).to eq 3
        expect(@user.incoming_transactions).to include @incoming1
        expect(@user.incoming_transactions).to include @incoming2
      end
    end

    describe 'outgoing transactions' do
      it 'returns the right collection' do
        expect(@user.outgoing_transactions.count).to eq 2
        expect(@user.outgoing_transactions).to include @outgoing1
        expect(@user.outgoing_transactions).to include @outgoing2
      end
    end

    describe 'num_credits' do
      it 'returns the credits count' do
        # initial credit
        expect(@user.num_credits).to eq (110 + 100)
      end
    end

    describe 'all_transactions' do
      it 'returns a full list of transactions' do
        expect(@user.all_transactions.count).to eq 5
      end
    end
  end

  describe 'can_send?' do
    before do
      @user = create(:user)
    end

    it 'allows valid transactions' do
      expect(@user.can_send?(100)).to eq true
    end

    it 'does not allow sending more than you have' do
      expect(@user.can_send?(101)).to eq false
    end
  end
end

