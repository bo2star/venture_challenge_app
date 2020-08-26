class Student::FinancialsController < StudentController

  before_action :require_student
  before_action :require_team
  before_action :require_shop

  def show
    @financials = {
      products: current_team.shop.products.as_json,
      expenses: current_team.expenses.order(created_at: :asc).as_json
    }.to_json
  end

  def update
    financials = params[:financials]
    shop = current_team.shop

    ActiveRecord::Base.transaction do
      # Update products' unit costs.
      if products = financials[:products]
        products.each do |product_params|
          unit_cost = product_params[:unit_cost]
          product = shop.products.find(product_params[:id])
          product.update!(unit_cost: unit_cost)
        end
      end

      # Update expenses
      #
      # We completely wipe out expenses and re-create them.
      # This is a little inefficient, but keeps things really
      # simple.
      # 
      current_team.expenses.destroy_all
      financials[:expenses].to_a.each do |expense_params|
        current_team.expenses.create!(
          name: expense_params[:name],
          amount: expense_params[:amount]
        )
      end
    end

    head :ok
  end

end