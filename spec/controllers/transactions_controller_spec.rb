require 'rails_helper'

describe TransactionsController, type: :controller do
  describe 'create' do
    context 'unauthorized' do
      it 'stops the user' do
        post :create, params: { transaction: attributes_for(:transaction) }
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'signed in' do
      before do
        @user = create(:user)
        @request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in @user
      end

      context 'valid transaction' do
        it 'shows confirmation notice' do
          post :create, params: {
            transaction: {
              num_credits: 10,
              recipient_id: create(:user).id,
            }
          }
          expect(response).to redirect_to root_url
          expect(@user.num_credits).to eq 90
          expect(flash[:notice]).to include 'sent 10 credits'
        end
      end

      context 'sending more than we have' do
        it 'shows alert' do
          post :create, params: {
            transaction: {
              num_credits: 120,
              recipient_id: create(:user).id,
            }
          }
          expect(response).to redirect_to root_url
          expect(@user.num_credits).to eq 100
          expect(flash[:alert]).to include "can't send more credits than you own"
        end
      end

      context 'invalid transaction' do
        it 'shows alert' do
          post :create, params: {
            transaction: {
              num_credits: -10,
              recipient_id: create(:user).id,
            }
          }
          expect(response).to redirect_to root_url
          expect(@user.num_credits).to eq 100
          expect(flash[:alert]).to include "couldn't complete"
        end
      end
    end
  end
end

