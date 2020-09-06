# frozen_string_literal: true

module Spree
  class GraphqlController < ActionController::API
    include ActionController::MimeResponds
    include SetCurrentRequestDetails
    include Authentication
    include SetCurrentStoreDetails

    def execute
      render json: SolidusGraphqlApi::Schema.execute(
        params[:query],
        variables: ensure_hash(params[:variables]),
        context: {
          current_user: Current.user,
          current_ability: Current.ability,
          current_store: Current.store,
          current_order: Current.order,
          current_pricing_options: Current.pricing_opts,
          order_token: Current.order_token
        },
        operation_name: params[:operationName]
      )
    rescue StandardError => e
      raise e unless Rails.env.development?

      handle_error_in_development e
    end

    private

    # Handle form data, JSON body, or a blank value
    def ensure_hash(ambiguous_param)
      case ambiguous_param
      when String
        if ambiguous_param.present?
          ensure_hash(JSON.parse(ambiguous_param))
        else
          {}
        end
      when Hash
        ambiguous_param
      when ActionController::Parameters
        ambiguous_param.permit!
      when nil
        {}
      else
        raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
      end
    end

    def handle_error_in_development(error)
      logger.error error.message
      logger.error error.backtrace.join("\n")

      render json: { error: { message: error.message, backtrace: error.backtrace }, data: {} }, status: 500
    end
  end
end
