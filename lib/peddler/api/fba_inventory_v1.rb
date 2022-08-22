# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for FBA Inventory
    #
    # The Selling Partner API for FBA Inventory lets you programmatically retrieve information about inventory in
    # Amazon's fulfillment network.
    class FBAInventoryV1 < API
      # Returns a list of inventory summaries. The summaries returned depend on the presence or absence of the
      # startDateTime, sellerSkus and sellerSku parameters: - All inventory summaries with available details are
      # returned when the startDateTime, sellerSkus and sellerSku parameters are omitted. - When startDateTime is
      # provided, the operation returns inventory summaries that have had changes after the date and time specified. The
      # sellerSkus and sellerSku parameters are ignored. Important: To avoid errors, use both startDateTime and
      # nextToken to get the next page of inventory summaries that have changed after the date and time specified. -
      # When the sellerSkus parameter is provided, the operation returns inventory summaries for only the specified
      # sellerSkus. The sellerSku parameter is ignored. - When the sellerSku parameter is provided, the operation
      # returns inventory summaries for only the specified sellerSku. Note: The parameters associated with this
      # operation may contain special characters that must be encoded to successfully call the API. To avoid errors with
      # SKUs when encoding URLs, refer to URL Encoding. Usage Plan: | Rate (requests per second) | Burst | | ---- | ----
      # | | 2 | 2 | The x-amzn-RateLimit-Limit response header returns the usage plan rate limits that were applied to
      # the requested operation, when available. The table above indicates the default rate and burst values for this
      # operation. Selling partners whose business demands require higher throughput may see higher rate and burst
      # values than those shown here. For more information, see Usage Plans and Rate Limits in the Selling Partner API.
      #
      # @param [Boolean] details true to return inventory summaries with additional summarized inventory details and
      #   quantities. Otherwise, returns inventory summaries only (default value).
      # @param [String] granularity_type The granularity type for the inventory aggregation level.
      # @param [String] granularity_id The granularity ID for the inventory aggregation level.
      # @param [String] start_date_time A start date and time in ISO8601 format. If specified, all inventory summaries
      #   that have changed since then are returned. You must specify a date and time that is no earlier than 18 months
      #   prior to the date and time when you call the API. Note: Changes in inboundWorkingQuantity,
      #   inboundShippedQuantity and inboundReceivingQuantity are not detected.
      # @param [Array<String>] seller_skus A list of seller SKUs for which to return inventory summaries. You may
      #   specify up to 50 SKUs.
      # @param [String] seller_sku A single seller SKU used for querying the specified seller SKU inventory summaries.
      # @param [String] next_token String token returned in the response of your previous request. The string token will
      #   expire 30 seconds after being created.
      # @param [Array<String>] marketplace_ids The marketplace ID for the marketplace for which to return inventory
      #   summaries.
      # @return [Hash] The API response
      def get_inventory_summaries(granularity_type, granularity_id, marketplace_ids, details: nil,
        start_date_time: nil, seller_skus: nil, seller_sku: nil, next_token: nil)
        path = "/fba/inventory/v1/summaries"
        params = {
          "details" => details,
          "granularityType" => granularity_type,
          "granularityId" => granularity_id,
          "startDateTime" => start_date_time,
          "sellerSkus" => seller_skus,
          "sellerSku" => seller_sku,
          "nextToken" => next_token,
          "marketplaceIds" => marketplace_ids,
        }.compact

        retriable(delay: proc { |i| 2.0 * i }).get(path, params:)
      end

      # Requests that Amazon create product-details in the Sandbox Inventory in the sandbox environment. This is a
      # sandbox-only operation and must be directed to a sandbox endpoint. Refer to [Selling Partner API
      # sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more information.
      #
      # @param [Hash] create_inventory_item_request_body CreateInventoryItem Request Body Parameter.
      # @return [Hash] The API response
      def create_inventory_item(create_inventory_item_request_body)
        path = "/fba/inventory/v1/items"
        body = create_inventory_item_request_body

        post(path, body:)
      end

      # Requests that Amazon Deletes an item from the Sandbox Inventory in the sandbox environment. This is a
      # sandbox-only operation and must be directed to a sandbox endpoint. Refer to [Selling Partner API
      # sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more information.
      #
      # @param [String] seller_sku A single seller SKU used for querying the specified seller SKU inventory summaries.
      # @param [String] marketplace_id The marketplace ID for the marketplace for which the sellerSku is to be deleted.
      # @return [Hash] The API response
      def delete_inventory_item(seller_sku, marketplace_id)
        path = "/fba/inventory/v1/items/#{seller_sku}"
        params = {
          "marketplaceId" => marketplace_id,
        }.compact

        delete(path, params:)
      end

      # Requests that Amazon add items to the Sandbox Inventory with desired amount of quantity in the sandbox
      # environment. This is a sandbox-only operation and must be directed to a sandbox endpoint. Refer to [Selling
      # Partner API sandbox](https://developer-docs.amazon.com/sp-api/docs/the-selling-partner-api-sandbox) for more
      # information.
      #
      # @param [String] x_amzn_idempotency_token A unique token/requestId provided with each call to ensure idempotency.
      # @param [Hash] add_inventory_request_body List of items to add to Sandbox inventory.
      # @return [Hash] The API response
      def add_inventory(x_amzn_idempotency_token, add_inventory_request_body)
        path = "/fba/inventory/v1/items/inventory"
        body = add_inventory_request_body

        post(path, body:)
      end
    end
  end
end