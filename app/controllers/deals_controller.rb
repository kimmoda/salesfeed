class DealsController < ApplicationController
	before_action :authenticate_user!, :only => [:new, :create, :edit, :update, :destroy]

	def index
	end

	def show
		@deal = Deal.friendly.find_by_id(params[:id])
		return render_not_found if @deal.blank?
	end

	def new
		@deal = Deal.new
	end

	def create
		@deal = current_user.deals.create(deal_params)
		if @deal.valid?
			redirect_to root_path
		else
			render :new, status: :unprocessable_entity
		end
	end

	def edit
		@deal = Deal.friendly.find_by_id(params[:id])
		return render_not_found if @deal.blank?
		return render_not_found(:forbidden) if @deal.user != current_user
	end

	def update
		@deal = Deal.friendly.find_by_id(params[:id])
		return render_not_found if @deal.blank?
		return render_not_found(:forbidden) if @deal.user != current_user

		@deal.update_attributes(deal_params)
		
		if @deal.valid?
			redirect_to root_path
		else
			render :edit, status: :unprocessable_entity
		end 
	end

	def destroy
		@deal = Deal.friendly.find_by_id(params[:id])
		return render_not_found if @deal.blank?
		return render_not_found(:forbidden) if @deal.user != current_user
		@deal.destroy

		redirect_to root_path
	end

	private

	def deal_params
		params.require(:deal).permit(:title, :message, :deeplink)
	end

	def render_not_found(status=:not_found)
		render text: "#{status.to_s.titleize}", status: status
	end
end
