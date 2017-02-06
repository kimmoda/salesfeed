require 'rails_helper'

RSpec.describe DealsController, type: :controller do
	describe "deal#update action" do
		it "should allow users to successfully update deal" do
			deal = FactoryGirl.create(:deal, message: "Initial Value")
			patch :update, id: deal.id, deal: {message: "Changed"}
			expect(response).to redirect_to root_path
			deal.reload
			expect(deal.message).to eq "Changed"
		end

		it "should have http 404 error if the deal cannot be found" do
			patch :update, id: "YOLOSWAG", deal: {message: "Changed"}
			expect(response).to have_http_status(:not_found)
		end

		it "should render the edit form with an http status of unprocessable_entity" do
			deal = FactoryGirl.create(:deal, message: "Initial Value")
			patch :update, id: deal.id, deal: {message: ''}
			expect(response).to have_http_status(:unprocessable_entity)
			deal.reload
			expect(deal.message).to eq "Initial Value"
		end
	end
	describe "deal#edit action" do
		it "should successfully show the edit form if the deal is found" do
			deal = FactoryGirl.create(:deal)
			get :edit, id: deal.id
			expect(response).to have_http_status(:success)
		end

		it "should return a 404 error message if the deal is not found" do
			get :edit, id: "TACOCAT"
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "deal#show action" do
		it "should successfully show the page if the deal is found" do
			deal = FactoryGirl.create(:deal)
			get :show, id: deal.id
			expect(response).to have_http_status(:success)
		end
		it "should return a 404 error if the gram is not found" do
			get :show, id: "TACOCAT"
			expect(response).to have_http_status(:not_found)
		end
	end

	describe "deal#index action" do
		it "should successfully show the page" do
			get :index
			expect(response).to have_http_status(:success)
		end
	end

	describe "deal#new action" do
		it "should require users to be logged in" do
			get :new
			expect(response).to redirect_to new_user_session_path
		end

		it "should successfully show new form" do
			user = FactoryGirl.create(:user)
			sign_in user

			get :new
			expect(response).to have_http_status(:success)
		end
	end

	describe "deal#create action" do
		it "should require users to be logged in" do
			post :create, deal: { title: "first test", message: "Hello!", deeplink: "https://this.is.atest.com" }
			expect(response).to redirect_to new_user_session_path
		end
		it "should successfully create new deal in the database" do
			user = FactoryGirl.create(:user)
			sign_in user
			
			post :create, deal: { title: "first test", message: "Hello!", deeplink: "https://this.is.atest.com" }
			expect(response).to redirect_to root_path

			deal = Deal.last
			expect(deal.title).to eq("first test")
			expect(deal.message).to eq("Hello!")
			expect(deal.deeplink).to eq("https://this.is.atest.com")
			expect(deal.user).to eq(user)
		end
		it "should properly deal with validation errors" do
			user = FactoryGirl.create(:user)
			sign_in user
			
			deal_count = Deal.count
			post :create, deal: { title: '', message: '', deeplink: ''}
			expect(response).to have_http_status(:unprocessable_entity)
			expect(deal_count).to eq Deal.count
		end
	end

end
