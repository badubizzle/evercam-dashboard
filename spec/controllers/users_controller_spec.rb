require 'spec_helper'

describe UsersController do

  let!(:user) {create(:active_user)}
  let(:params) {
    {user: {
        forename: user.forename,
        lastname: user.lastname,
        username: user.username,
        email: user.email,
        password: 'password'
        },
      country: 'ie'}
  }
  let(:patch_params) {
    {id: user.username,
     'user-forename' => 'Aaaddd',
     'user-lastname' => 'Bbbeeee',
     email: "#{user.username}2@evercam.io",
     password: 'asdf',
     country: 'pl'}
  }
  let(:new_user_params) {
    id = SecureRandom.hex(8)
    {user: {forename: 'Joe',
            lastname: 'Bloggs',
            username: id,
            email: "#{id}@nowhere.com",
            password: 'password'},
      country: 'ie'}
  }

  describe 'GET #new' do
    it "renders the :new" do
      get :new
      expect(response.status).to eq(200)
      expect(response).to render_template :new
    end
  end

  describe 'GET #confirm' do
    it "confirms user if parameters are correct" do
      code = Digest::SHA1.hexdigest(user.username + user.created_at.to_s)
      get :confirm, {:u => user.username, :c => code}
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq('Successfully activated your account')
      expect(response).to redirect_to '/signin'
    end

    it "fails to confirm if parameters are incorrect" do
      get :confirm, {:u => user.username, :c => '123'}
      expect(response.status).to eq(302)
      expect(flash[:notice]).to eq('Activation code is incorrect')
      expect(response).to redirect_to '/signin'
    end
  end

  describe 'POST #create with wrong params' do
    it "renders the :new" do
      post :create, {}
      expect(response.status).to eq(302)
      expect(response).to redirect_to('/users/new')
    end
  end

  describe 'POST #create with correct params' do
    it "signs in and redirects to cameras index" do
      stub_request(:post, "#{EVERCAM_API}users.json").
        with(:body => "country=ie&email=#{CGI.escape(new_user_params[:user][:email])}&forename=Joe&lastname=Bloggs&password=password&username=#{new_user_params[:user][:username]}").
        to_return(:status => 200, :body => '{"users": [{}]}', :headers => {})
      #stub_request(:post, "#{EVERCAM_API}users").to_return(:status => 200, :body => '{"users": [{}]}', :headers => {})

      post :create, new_user_params
      expect(response.status).to eq(302)
      expect(response).to redirect_to "/"
    end
  end

  describe 'GET #settings' do
    it "redirects to signup" do
      get :settings, {id: 'tester'}
      expect(response).to redirect_to('/signin')
    end
  end

  describe 'POST #settings' do
    it "redirects to signup" do
      post :settings_update, {id: 'tester'}
      expect(response).to redirect_to('/signin')
    end
  end

  context 'with auth' do
    describe 'GET #settings' do
      it "renders the :settings" do
        stub_request(:patch, "#{EVERCAM_API}users/#{user.username}").
          to_return(:status => 200, :body => "", :headers => {})

        session['user'] = user.email
        get :settings, {id: user.username}
        expect(response.status).to eq(200)
        expect(response).to render_template :settings
      end
    end

    describe 'POST #settings_update with wrong params' do
      it "fails and renders user settings" do
        stub_request(:patch, "#{EVERCAM_API}users/#{user.username}.json").
          with(:body => "api_id=#{user.api_id}&api_key=#{user.api_key}&forename=",).
          to_return(:status => 400, :body => '{"message": ["forename cannot be blank"]}', :headers => {})

        session['user'] = user.email
        post :settings_update, {id: user.username, 'user-forename' => ''}
        expect(response.status).to eq(302)
        expect(response).to redirect_to "/users/#{user.username}/settings"
        expect(flash[:message]).to eq("An error occurred updating your details. Please try again and, if the problem persists, contact support.")
      end
    end

    describe 'POST #settings_update with correct params, but for different user' do
      it "signs out and redirects to sign in" do
        session['user'] = params[:user][:email]
        post :settings_update, {id: 'tester'}
        expect(response.status).to eq(302)
        expect(response).to redirect_to '/signin'
      end
    end

    describe 'POST #settings_update with correct params' do
      it "updates and renders user settings" do
        stub_request(:patch, "#{EVERCAM_API}users/#{user.username}.json").
          with(:body => "api_id=#{user.api_id}&api_key=#{user.api_key}&country=pl&forename=Aaaddd&lastname=Bbbeeee").
          to_return(:status => 200, :body => '{"users": [{}]}', :headers => {})

        session['user'] = params[:user][:email]
        post :settings_update, patch_params
        expect(response.status).to eq(302)
        expect(response).to redirect_to("/users/#{user.username}/settings")
        expect(flash[:message]).to eq('Settings updated successfully')
      end
    end
  end

end
