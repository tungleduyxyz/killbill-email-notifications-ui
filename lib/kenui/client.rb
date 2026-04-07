# frozen_string_literal: true

module Killbill
  module Kenui
    class KenuiClient < KillBillClient::Model::Resource
      KILLBILL_EMAIL_NOTIFICATION_PREFIX = '/plugins/killbill-email-notifications/v1'

      class << self
        def get_events_to_consider(options = {})
          path = "#{KILLBILL_EMAIL_NOTIFICATION_PREFIX}/eventsToConsider"
          response = KillBillClient::API.get path, {}, options
          JSON.parse(response.body)
        end

        def get_configurations(account_ids, options = {})
          path = "#{KILLBILL_EMAIL_NOTIFICATION_PREFIX}/accounts"
          response = KillBillClient::API.get path, { kbAccountId: account_ids }, options

          JSON.parse(response.body).map(&:symbolize_keys)
        rescue StandardError => e
          [false, e.message.to_s]
        end

        def get_configuration_per_account(account_id, options = {})
          path = "#{KILLBILL_EMAIL_NOTIFICATION_PREFIX}/accounts/#{account_id}"
          response = KillBillClient::API.get path, {}, options

          JSON.parse(response.body).map(&:symbolize_keys)
        rescue StandardError => e
          [false, e.message.to_s]
        end

        def set_configuration_per_account(account_id, event_types, user = 'kenui', reason = nil, comment = nil, options = {})
          path = "#{KILLBILL_EMAIL_NOTIFICATION_PREFIX}/accounts/#{account_id}"
          more_options = {}
          more_options[:user] = user
          more_options[:reason] = reason unless reason.nil?
          more_options[:comment] = comment unless comment.nil?

          KillBillClient::API.post path, event_types, {}, options.merge(more_options)

          [true, "Email notifications for account #{account_id} was successfully updated"]
        rescue StandardError => e
          [false, e.message.to_s]
        end

        def email_notification_plugin_available?(options = nil)
          # inquire if the plugin is listening
          path = KILLBILL_EMAIL_NOTIFICATION_PREFIX
          KillBillClient::API.get path, nil, options

          [true, nil]
        # Response error if email notification plugin is not listening
        rescue KillBillClient::API::ResponseError => e
          [false, e.message.to_s]
        end
      end
    end
  end
end
