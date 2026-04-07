# frozen_string_literal: true

require 'test_helper'

module Kenui
  class EmailNotificationsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test 'should get index' do
      get email_notifications_url
      assert_response :success
    end

    test 'should set configuration' do
      account_id = SecureRandom.uuid.to_s
      configuration = { account_id:,
                        event_types: %w[INVOICE_NOTIFICATION INVOICE_CREATION] }

      post email_notifications_configuration_path, params: { configuration: }
      follow_redirect!
      assert_equal email_notifications_path, path
      assert_equal "Email notifications for account #{account_id} was successfully updated", flash[:notice]

      get email_notifications_get_configuration_path, as: :json, params: { account_id: }
      assert_response :success
      json = response.parsed_body
      assert_equal(2, json['data'].size)
      assert_equal(account_id, json['data'][0]['kbAccountId'])
    end
  end
end
