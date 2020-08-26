module Sortable
  extend ActiveSupport::Concern

  module ClassMethods

    def sort(ordered_ids)
      transaction do
        ordered_ids.each.with_index do |id, order|
          scoped.find(id).update!(order: order)
        end
      end
    end

    def sorted
      scoped.order(order: :asc)
    end

    def build_at_end(attributes)
      scoped.build(attributes.merge(order: next_order))
    end

    def next_order
      scoped.maximum(:order).to_i + 1
    end

    def scoped
      where(nil)
    end

  end

end