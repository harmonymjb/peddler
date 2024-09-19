# frozen_string_literal: true

require "helper"

require "peddler/api/feeds_2021_06_30"

module Peddler
  class API
    class Feeds20210630Test < Minitest::Test
      def setup
        super
        @api = Feeds20210630.new(aws_region, request_access_token)
      end

      def test_create_feed_document
        res = @api.create_feed_document(
          "contentType" => "application/json; charset=UTF-8",
        )

        assert_predicate(res.status, :created?)
      end

      def test_create_feed
        feed_document_id = "amzn1.tortuga.4.eu.123"
        url = "https://tortuga-prod-eu.s3-eu-west-1.amazonaws.com/123"

        json = {
          "header": {
            "sellerId": "A34PPN1ZLYCOGT",
            "version": "2.0",
            "issueLocale": "en_US",
          },
          "messages": [
            {
              "messageId": 1,
              "sku": "SKU123",
              "operationType": "UPDATE",
              "productType": "PRODUCT",
              "requirements": "LISTING_OFFER_ONLY",
              "attributes": {
                "merchant_suggested_asin": [{
                  "value": "188864544X",
                  "marketplace_id": "A1F83G8C2ARO7P",
                }],
                "condition_type": [{
                  "value": "new_new",
                  "marketplace_id": "A1F83G8C2ARO7P",
                }],
                "merchant_shipping_group": [
                  {
                    "value": "legacy-template-id",
                    "marketplace_id": "A1F83G8C2ARO7P",
                  },
                ],
                "fulfillment_availability": [{
                  "fulfillment_channel_code": "DEFAULT",
                  "quantity": 1,
                  "lead_time_to_ship_max_days": 3,
                }],
                "purchasable_offer": [{
                  "currency": "GBP",
                  "our_price": [{
                    "schedule": [{
                      "value_with_tax": 400,
                    }],
                  }],
                  "minimum_seller_allowed_price": [{
                    "schedule": [{
                      "value_with_tax": 350,
                    }],
                  }],
                  "maximum_seller_allowed_price": [{
                    "schedule": [{
                      "value_with_tax": 450,
                    }],
                  }],
                  "marketplace_id": "A1F83G8C2ARO7P",
                }],
              },
            },
          ],
        }
        res = HTTP.put(url, json:)

        assert_predicate(res.status, :ok?)

        payload = {
          "feedType" => "JSON_LISTINGS_FEED",
          "marketplaceIds" => ["A1F83G8C2ARO7P"],
          "inputFeedDocumentId" => feed_document_id,
        }
        res = @api.create_feed(payload)

        assert_predicate(res.status, :accepted?)
      end

      def test_get_feed
        feed_id = "123"
        res = @api.get_feed(feed_id)

        assert_predicate(res.status, :ok?)
      end

      def test_get_feed_document
        feed_document_id = "amzn1.tortuga.4.eu.123"
        res = @api.get_feed_document(feed_document_id)

        assert_predicate(res.status, :ok?)

        # Just exploring the result feed document
        url = res.parse.dig("url")
        res = HTTP.get(url)
        body = Zlib::GzipReader.new(res).read

        assert(JSON.parse(body))
      end
    end
  end
end