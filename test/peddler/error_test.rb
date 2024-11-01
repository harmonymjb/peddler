# frozen_string_literal: true

require "helper"
require "peddler/error"

module Peddler
  class ErrorTest < Minitest::Test
    def test_invalid_input
      response = '{"errors":[{"code":"InvalidInput","message":"InvalidInput"}]}'
      error = Error.build(response)

      assert_kind_of(Error::InvalidInput, error)
    end

    def test_not_found
      response = '{"errors":[{"code":"NotFound","message":"NotFound"}]}'
      error = Error.build(response)

      assert_kind_of(Error::NotFound, error)
    end

    def test_quota_exceeded
      response = '{"errors":[{"code":"QuotaExceeded","message":"You exceeded your quota for the requested resource."}]}'
      error = Error.build(response)

      assert_kind_of(Error::QuotaExceeded, error)
    end

    def test_unauthorized
      response = '{"errors":[{"code":"Unauthorized","message":"Access to requested resource is denied."}]}'
      error = Error.build(response)

      assert_kind_of(Error::Unauthorized, error)
    end

    def test_other_error
      refute_includes(Error.constants, :OtherError)

      response = '{"errors":[{"code":"OtherError","message":"OtherError"}]}'
      error = Error.build(response)

      assert_includes(Error.constants, :OtherError)
      assert_kind_of(Error::OtherError, error)
    end

    def test_fallback_on_message
      response = '{"errors":[{"code":"400","message":"Invalid Input"}]}'
      error = Error.build(response)

      assert_kind_of(Error::InvalidInput, error)
    end
  end
end
