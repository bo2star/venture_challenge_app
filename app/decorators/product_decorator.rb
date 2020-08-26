class ProductDecorator < Draper::Decorator

  delegate_all

  def price
    object.total_revenue / object.quantity
  end

  def margin
    ((price - object.unit_cost) / price) * 100
  end


end
