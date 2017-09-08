module Genability
  class Client
    module Calculate
      def calculate_metadata(tariff_id, options = {})
        get("v1/calculate/#{tariff_id}", calculate_meta_params(options)).results
      end

      def calculate(tariff_id, options = {})
        post("v1/calculate/#{tariff_id}", calculate_params(options)).results.first
      end

      def calculate_by_account(provider_account_id, options = {})
        post("v1/accounts/pid/#{provider_account_id}/calculate", calculate_params(options)).results.first
      end

      private

      def calculate_meta_params(options)
        params = {
          "fromDateTime" => format_to_iso8601(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_iso8601(options[:to] || options[:to_date_time]),
          "billingPeriod" => convert_to_boolean(options[:billing_period])
        }.delete_if{ |k,v| v.nil? }
        params.merge(
          options.select{ |k,v| params[ruby_to_camel_case(k)].nil? }.
          map{ |k,v| [ruby_to_camel_case(k), v] }.
          to_h
        )
      end

      def calculate_params(options)
        {
          "accountId" => options[:account_id],
          "providerAccountId" => options[:provider_account_id],
          "minimums" => options[:minimums],
          "fromDateTime" => format_to_iso8601(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_iso8601(options[:to] || options[:to_date_time]),
          "billingPeriod" => convert_to_boolean(options[:billing_period]),
          "detailLevel" => convert_to_upcase(options[:detail_level]),
          "tiers" => convert_to_upcase(options[:tiers]),
          "groupBy" => convert_to_upcase(options[:group_by]),
          "tariffInputs" => tariff_inputs_params(options[:tariff_inputs]),
          "rateInputs" => rate_inputs_params(options[:rate_inputs]),
          "serviceType" => options[:service_type],
          "masterTariffId" => options[:master_tariff_id],
          "profileId" => options[:profile_id]
        }.
        delete_if{ |k,v| v.nil? }
      end
    end
  end
end

