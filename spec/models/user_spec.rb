require 'rails_helper'

describe User do
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
      expect(@user.incoming_transactions.count).to eq 2
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
      expect(@user.num_credits).to eq 110
    end
  end
end
