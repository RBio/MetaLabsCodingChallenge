class Api::PurchasesController < Api::ApiController
  before_action :authorize_request
  rescue_from OutOfStockError, :with => :bad_request

  def index
    render json: @current_user.purchases
  end

  def create
    purchase = PurchasesService.make_purchase(@current_user)
    render json: PurchaseSerializer.new(purchase).to_json
  end
end
    