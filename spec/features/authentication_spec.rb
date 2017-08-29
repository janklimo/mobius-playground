require 'rails_helper'

feature 'Authentication' do
  context 'signed in' do
    before do
      user = create(:user)
      login_as(user, scope: :user)
    end

    scenario 'is taken to the dashboard' do
      visit root_path
      expect(page).to have_content 'yay'
    end
  end

  context 'logged out' do
    scenario 'user is taken to the landing page' do
      visit root_path
      expect(page).to have_content 'To create a new account'
    end
  end
end

