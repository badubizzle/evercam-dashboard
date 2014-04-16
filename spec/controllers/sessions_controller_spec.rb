require 'spec_helper'

describe SessionsController do

  let(:user) {
    create(:active_user)
  }

  describe 'GET #new without auth' do
    it "rerenders new" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'GET #new with auth' do
    it "redirects to index" do
      session['user'] = user.email
      get :new
      expect(response).to redirect_to :cameras_index
    end
  end

  describe 'POST #create without auth' do
    it "rerenders signin" do
      post :create
      expect(response).to render_template :new
    end
  end

  describe 'POST #create with wrong credentials' do
    it "rerenders signin" do
      post :create, {session: {email: user.email, password: 'xxx'}}
      expect(response).to render_template :new
    end
  end

  describe 'POST #create with correct credentials' do
    it "rerenders signin" do
      post :create, {session: {email: user.email, password: 'password'}}
      expect(response).to redirect_to :cameras_index
    end
  end

  describe 'DELETE #destroy with correct credentials' do
    it "redirects to signin" do
      delete :destroy
      expect(response).to redirect_to '/signin'
    end
  end

end
