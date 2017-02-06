require 'rails_helper'

RSpec.describe DonationsController, type: :controller do
  
  describe 'GET new' do
    it 'has status 200' do
      get :new
      expect(response.status).to eq (200)
      expect(response).to render_template :new
    end
  end
  
  describe 'POST create' do
    
  end

end
