# frozen_string_literal: true

module SetCurrentStoreDetails
  extend ActiveSupport::Concern

  included do
    before_action do
      Current.order_token = request.headers["X-Spree-Order-Token"]
      Current.store = Spree::Config.current_store_selector_class.new(request).store
      Current.order = current_order_by_current_user || current_order_by_guest_token
      Current.pricing_opts = current_pricing_options
    end
  end

  private

  def current_order_by_current_user
    Current.user&.last_incomplete_spree_order(store: Current.store)
  end

  def current_order_by_guest_token
    incomplete_orders = Spree::Order.incomplete
    incomplete_orders = incomplete_orders.where(store: Current.store) if Current.store

    incomplete_orders.find_by(guest_token: Current.order_token)
  end

  def current_pricing_options
    Spree::Config.pricing_options_class.new(
      currency: Current.store&.default_currency.presence || Spree::Config[:currency],
      country_iso: Current.store&.cart_tax_country_iso.presence
    )
  end
end
