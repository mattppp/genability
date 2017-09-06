module Genability
  class Client

    module AccountTariff

      def add_account_tariff(account_id, options = {})
        post("v1/accounts/#{account_id}/tariffs", add_account_tariff_params(options)).results.first
      end

      def upsert_account_tariff(account_id, options = {})
        put("v1/accounts/#{account_id}/tariffs", add_account_tariff_params(options)).results.first
      end

      def delete_account_tariff(account_id, options = {})
        delete("v1/accounts/#{account_id}/tariffs", delete_account_tariff_params(options))
      end

      def add_provider_account_tariff(provider_account_id, options = {})
        post("v1/accounts/pid/#{provider_account_id}/tariffs", add_account_tariff_params(options)).results.first
      end

      def upsert_provider_account_tariff(provider_account_id, options = {})
        put("v1/accounts/pid/#{provider_account_id}/tariffs", add_account_tariff_params(options)).results.first
      end

      def delete_provider_account_tariff(provider_account_id, options = {})
        delete("v1/accounts/pid/#{provider_account_id}/tariffs", delete_account_tariff_params(options))
      end

      private

      def add_account_tariff_params(options)
        {
          "masterTariffId" => options[:master_tariff_id],
          "serviceType" => convert_to_upcase(options[:service_type]),
          "effectiveDate" => format_to_ymd(options[:effective_date]),
          "endDate" => format_to_ymd(options[:end_date])
        }.
        delete_if{ |k,v| v.nil? }
      end

      def delete_account_tariff_params(options)
        {
          "effectiveDate" => format_to_ymd(options[:effective_date])
        }.
        delete_if{ |k,v| v.nil? }
      end
    end
  end
end

