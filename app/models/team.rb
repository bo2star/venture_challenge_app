# == Schema Information
#
# Table name: teams
#
#  id                  :integer          not null, primary key
#  competition_id      :integer          indexed
#  name                :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  color               :string(255)
#  cached_total_points :integer          default("0")
#  coupon_code         :string
#
# Indexes
#
#  index_teams_on_competition_id  (competition_id)
#

class Team < ActiveRecord::Base

  POINTS_PER_CUSTOMER = 10
  POINTS_PER_DOLLAR_REVENUE = 1
  POINTS_PER_DOLLAR_PROFIT = 2

  belongs_to :competition
  has_one :shop, dependent: :destroy
  has_many :shop_requests, dependent: :destroy
  has_many :students, dependent: :nullify
  has_many :learning_resources, class_name: 'TeamLearningResource', dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :expenses
  has_many :team_comments

  validates :name,
            presence: true,
            uniqueness: { scope: :competition },
            on: :create

  # Include only teams with a launched shop.
  scope :with_shop, -> { joins(:shop) }

  def only_member?(student)
    students.size == 1 && students.first == student
  end

  def report_range
    competition.elapsed_date_range
  end

  def launched_shop?
    !!shop
  end

  def task_with_code(code)
    tasks.find_by!(code: code)
  end

  def allowed_tasks
    launched_shop? ? tasks.all : tasks.shop_optional
  end

  def pending_tasks
    allowed_tasks.incomplete
  end

  def completed_tasks
    tasks.complete
  end

  def shop_url
    launched_shop? ? shop.url : nil
  end

  def customers
    launched_shop? ? shop.customers_acquired_during(report_range) : Customer.none
  end

  def orders
    # NOTE: We only count "paid" orders, placed during the competition
    # time window.
    launched_shop? ? shop.orders_placed_during(report_range).paid : Order.none
  end

  def referrals
    launched_shop? ? shop.referrals_during(report_range) : Referral.none
  end

  def products
    launched_shop? ? shop.products : Product.none
  end

  def total_customers
    customers.size
  end

  def total_orders
    orders.size
  end

  def total_revenue
    orders.sum(:subtotal_price)
  end

  def total_profit
    if shop && shop.products.any?
      total_revenue - total_cost
    else
      0
    end
  end

  def daily_customers
    h = customers.group_by_acquisition_day.count
    DailyMetric.new(h)
  end

  def daily_orders
    h = orders.group_by_placement_day.count
    DailyMetric.new(h)
  end

  def daily_revenue
    h = orders.group_by_placement_day.sum(:subtotal_price)
    DailyMetric.new(h)
  end

  def daily_profit
    if shop && shop.products.any?
      daily_revenue - daily_cost
    else
      DailyMetric.zero
    end
  end

  def rank
    competition.team_rank(self)
  end

  def total_points
    total_task_points +
      total_customers * POINTS_PER_CUSTOMER +
      total_revenue * POINTS_PER_DOLLAR_REVENUE +
      [total_profit, 0].max * POINTS_PER_DOLLAR_PROFIT
  end

  def daily_points
    points = daily_task_points +
      daily_customers * POINTS_PER_CUSTOMER +
      daily_revenue * POINTS_PER_DOLLAR_REVENUE

    # We only include the profit if it is positive.
    if total_profit > 0
      points + daily_profit * POINTS_PER_DOLLAR_PROFIT
    else
      points
    end
  end

  def latest_pending_shop_request
    shop_requests.pending.order(created_at: :desc).first
  end

  # Has this team started a shop request but not completed it?
  # This should only be true in the short period while a team is confirming the application charge,
  # after they've already setup our application for their shopify shop. If it persists, there was
  # a problem while they were confirmation the application charge.
  def pending_shop_request?
    !launched_shop? && latest_pending_shop_request
  end

  # Does this team's shop have any financials that
  # we are waiting for them to fill out?
  #
  def pending_financials?
    shop && shop.pending_products.any?
  end

  def total_cost
    fixed_cost + product_cost
  end

  def fixed_cost
    expenses.sum(:amount).to_f
  end

  # Cost of products with a unit cost specified.
  def product_cost
    product_with_unit_cost + product_without_unit_cost
  end

  def product_with_unit_cost
    # Sum the unit cost * quantity for all line items for
    # products where a unit_cost is specified.
    shop.products.where.not(unit_cost: nil).sum('unit_cost * quantity')
  end

  private

    def total_task_points
      completed_tasks.total_points
    end

    def daily_task_points
      h = completed_tasks.group_by_completion_day.total_points
      DailyMetric.new(h)
    end

    # Cost of products without a unit cost specified.
    def product_without_unit_cost
      shop.products.where(unit_cost: nil).sum(:total_revenue).to_f
    end

    def daily_fixed_cost
      # Apply fixed costs to the first day of the competition.
      DailyMetric.delta(report_range.first, fixed_cost)
    end

    def daily_product_cost
      # Compute the sum of the unit_cost * quantity for all
      # line_items for this teams' products which have a unit_cost
      # assigned, grouped by the day the order was placed.
      h = query(<<-SQL
        select o.placed_at::date as date, sum(p.unit_cost * li.quantity) as profit
        from line_items li
        inner join products p
          on p.uid = li.product_uid
          and p.unit_cost is not null
          and p.shop_id = #{shop.id}
        inner join orders o on o.id = li.order_id
        where financial_status = 'paid'
        group by o.placed_at::date;
      SQL
      ).inject({}) { |sum, row| sum.merge(row['date'] => row['profit'].to_f) }
      with_unit_cost = DailyMetric.new(h)

      without_unit_cost = DailyMetric.delta(report_range.first, product_without_unit_cost)

      with_unit_cost + without_unit_cost
    end

    def daily_cost
      daily_fixed_cost + daily_product_cost
    end

    def query(sql)
      ActiveRecord::Base.connection.execute(sql)
    end

end
