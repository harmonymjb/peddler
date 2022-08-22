# frozen_string_literal: true

require "peddler/api"

module Peddler
  class API
    # Selling Partner API for Pricing
    #
    # The Selling Partner API for Pricing helps you programmatically retrieve product pricing and offer information for
    # Amazon Marketplace products.
    class ProductPricingV0 < API
      # Returns pricing information for a seller's offer listings based on seller SKU or ASIN.
      # @note The parameters associated with this operation may contain special characters that require URL encoding to
      #   call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param [Array<String>] asins A list of up to twenty Amazon Standard Identification Number (ASIN) values used to
      #   identify items in the given marketplace.
      # @param [Array<String>] skus A list of up to twenty seller SKU values used to identify items in the given
      #   marketplace.
      # @param [String] item_type Indicates whether ASIN values or seller SKU values are used to identify items. If you
      #   specify Asin, the information in the response will be dependent on the list of Asins you provide in the Asins
      #   parameter. If you specify Sku, the information in the response will be dependent on the list of Skus you
      #   provide in the Skus parameter.
      # @param [String] item_condition Filters the offer listings based on item condition. Possible values: New, Used,
      #   Collectible, Refurbished, Club.
      # @param [String] offer_type Indicates whether to request pricing information for the seller's B2C or B2B offers.
      #   Default is B2C.
      # @return [Hash] The API response
      def get_pricing(marketplace_id, item_type, asins: nil, skus: nil, item_condition: nil, offer_type: nil)
        path = "/products/pricing/v0/price"
        params = {
          "MarketplaceId" => marketplace_id,
          "Asins" => asins,
          "Skus" => skus,
          "ItemType" => item_type,
          "ItemCondition" => item_condition,
          "OfferType" => offer_type,
        }.compact

        retriable(delay: proc { |i| 0.5 * i }).get(path, params:)
      end

      # Returns competitive pricing information for a seller's offer listings based on seller SKU or ASIN.
      # @note The parameters associated with this operation may contain special characters that require URL encoding to
      #   call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param [Array<String>] asins A list of up to twenty Amazon Standard Identification Number (ASIN) values used to
      #   identify items in the given marketplace.
      # @param [Array<String>] skus A list of up to twenty seller SKU values used to identify items in the given
      #   marketplace.
      # @param [String] item_type Indicates whether ASIN values or seller SKU values are used to identify items. If you
      #   specify Asin, the information in the response will be dependent on the list of Asins you provide in the Asins
      #   parameter. If you specify Sku, the information in the response will be dependent on the list of Skus you
      #   provide in the Skus parameter. Possible values: Asin, Sku.
      # @param [String] customer_type Indicates whether to request pricing information from the point of view of
      #   Consumer or Business buyers. Default is Consumer.
      # @return [Hash] The API response
      def get_competitive_pricing(marketplace_id, item_type, asins: nil, skus: nil, customer_type: nil)
        path = "/products/pricing/v0/competitivePrice"
        params = {
          "MarketplaceId" => marketplace_id,
          "Asins" => asins,
          "Skus" => skus,
          "ItemType" => item_type,
          "CustomerType" => customer_type,
        }.compact

        retriable(delay: proc { |i| 0.5 * i }).get(path, params:)
      end

      # Returns the lowest priced offers for a single SKU listing.
      # @note The parameters associated with this operation may contain special characters that require URL encoding to
      #   call the API. To avoid errors with SKUs when encoding URLs, refer to [URL
      #   Encoding](https://developer-docs.amazon.com/sp-api/docs/url-encoding).
      #
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param [String] item_condition Filters the offer listings based on item condition. Possible values: New, Used,
      #   Collectible, Refurbished, Club.
      # @param [String] seller_sku Identifies an item in the given marketplace. SellerSKU is qualified by the seller's
      #   SellerId, which is included with every operation that you submit.
      # @param [String] customer_type Indicates whether to request Consumer or Business offers. Default is Consumer.
      # @return [Hash] The API response
      def get_listing_offers(marketplace_id, item_condition, seller_sku, customer_type: nil)
        path = "/products/pricing/v0/listings/#{seller_sku}/offers"
        params = {
          "MarketplaceId" => marketplace_id,
          "ItemCondition" => item_condition,
          "CustomerType" => customer_type,
        }.compact

        retriable(delay: proc { |i| 1.0 * i }).get(path, params:)
      end

      # Returns the lowest priced offers for a single item based on ASIN.
      #
      # @param [String] marketplace_id A marketplace identifier. Specifies the marketplace for which prices are
      #   returned.
      # @param [String] item_condition Filters the offer listings to be considered based on item condition. Possible
      #   values: New, Used, Collectible, Refurbished, Club.
      # @param [String] asin The Amazon Standard Identification Number (ASIN) of the item.
      # @param [String] customer_type Indicates whether to request Consumer or Business offers. Default is Consumer.
      # @return [Hash] The API response
      def get_item_offers(marketplace_id, item_condition, asin, customer_type: nil)
        path = "/products/pricing/v0/items/#{asin}/offers"
        params = {
          "MarketplaceId" => marketplace_id,
          "ItemCondition" => item_condition,
          "CustomerType" => customer_type,
        }.compact

        retriable(delay: proc { |i| 0.5 * i }).get(path, params:)
      end

      # Returns the lowest priced offers for a batch of items based on ASIN.
      #
      # @param [Hash] get_item_offers_batch_request_body
      # @return [Hash] The API response
      def get_item_offers_batch(get_item_offers_batch_request_body)
        path = "/batches/products/pricing/v0/itemOffers"
        body = get_item_offers_batch_request_body

        retriable(delay: proc { |i| 0.1 * i }).post(path, body:)
      end

      # Returns the lowest priced offers for a batch of listings by SKU.
      #
      # @param [Hash] get_listing_offers_batch_request_body
      # @return [Hash] The API response
      def get_listing_offers_batch(get_listing_offers_batch_request_body)
        path = "/batches/products/pricing/v0/listingOffers"
        body = get_listing_offers_batch_request_body

        retriable(delay: proc { |i| 0.5 * i }).post(path, body:)
      end
    end
  end
end