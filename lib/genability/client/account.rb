module Genability
  class Client

    module Account

      def add_account(options = {})
        post("v1/accounts", add_account_params(options)).results.first
      end

      def upsert_account(options = {})
        put("v1/accounts", add_account_params(options)).results.first
      end

      def delete_account(account_id)
        delete("v1/accounts/#{account_id}")
      end

      def account(account_id, options = {})
        get("v1/accounts/#{account_id}", account_params(options)).results.first
      end

      def provider_account(provider_account_id, options = {})
        get("v1/accounts/pid/#{provider_account_id}", account_params(options)).results.first
      end

      def accounts(options = {})
        get("v1/accounts", accounts_params(options)).results
      end

      private

      def add_account_params(options)
        {
          "providerAccountId" => options[:provider_account_id],
          "accountName" => options[:account_name],
          "customerOrgId" => options[:customer_org_id],
          "customerOrgName" => options[:customer_org_name],
          "address" => address_params(options[:address]),
          "properties" => properties_params(options[:properties])
        }.
        delete_if{ |k,v| v.nil? }
      end

      def account_params(options)
        {
          "fields" => options[:fields]
        }.
        delete_if{ |k,v| v.nil? }
      end

      def accounts_params(options)
        pagination_params(options).
        merge( search_params(options) )
      end

      def address_params(options)
        return nil if options.nil?
        {
          "addressString" => options[:address_string],
          "addressName" => options[:address_name],
          "address1" => options[:address1],
          "address2" => options[:address2],
          "city" => options[:city],
          "state" => options[:state],
          "zip" => options[:zip],
          "country" => options[:country],
          "lon" => options[:lon],
          "lat" => options[:lat]
        }.
        delete_if{ |k,v| v.nil? }
      end

    end
  end
end

