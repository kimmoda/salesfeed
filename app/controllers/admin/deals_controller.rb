class Admin::DealsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin

  def index
    @deals = Deal.all
    @messages = Message.all
    @subcategories = Subcategory.all
    respond_to do |format|
          format.html
          format.csv { send_data @deals.to_csv, filename: "deals-#{Date.today}.csv"}
          format.csv { send_data @subcategories, filename: "subcategories-#{Date.today}.csv"}
          format.xlsx
    end
  end

	def import
      Deal.import(params[:file])
      flash[:notice] = 'File has been imported'
      redirect_to root_path
    end
    
	def edit_multiple
     	@deals = Deal.where(id: deal_params[:deal_ids])
     	return render_not_found if @deals.blank?
     	return render_not_found(:forbidden) if @deals.first.user != current_user
	rescue ActiveRecord::RecordNotFound
		return render_not_found
	end

	def update_multiple
		@deals = Deal.friendly.update(params[:deals].keys, params[:deals].values)
		return render_not_found(:forbidden) if @deals.first.user != current_user
		
		@deals.reject! { |deal| deal.errors.empty? }
		if @deals.empty?
			redirect_to root_path
		else
			render "edit_multiple"
		end
	end

  private

  def deal_params
    params.require(:deal).permit(:title, :message, :deeplink, :picture, :retailer_id, {deal_ids: []}, 
      :category_id, :gender_id, :subcategory_id, :starts, :ends, :code, :terms)
  end

  def authenticate_admin
    unless current_user && current_user.try(:admin?)
      return render_not_found(:forbidden)
      redirect_to root_path
    end
  end
end
