
class Current < ActiveSupport::CurrentAttributes
  attribute :store, :user, :order, :order_token, :ability, :pricing_opts
  attribute :request_id, :user_agent, :ip_address

  def user=(user)
    super

    Current.ability = Spree::Ability.new(user)
  end
end
