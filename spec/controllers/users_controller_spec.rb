require 'rails_helper'

describe UsersController, type: :controller do
  describe 'current' do
    context 'unauthorized' do
      it 'stops the user' do
        get :current
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'authorized' do
      before do
        @user = create(:user)
        sign_in @user
        create(:transaction, num_credits: 42, recipient: @user)
      end
      it 'returns all required data' do
        get :current
        resp = JSON.parse(response.body)
        expect(resp['email']).to eq @user.email
        expect(resp['num_credits']).to eq 142

        # do not return anything else
        expect(resp['id']).to be_nil
      end
    end
  end
end

