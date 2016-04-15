module Genability
  class Client
    module Incentive

      # Returns a list of incentives.
      def incentives(options = {})
        get("beta/incentives", incentives_params(options)).results
      end

      # Returns one incentive.
      def incentive(incentive_id, options = {})
        get("beta/incentives/#{incentive_id}", incentive_params(options)).results.first
      end

      private

      def incentives_params(options)
        params = {
          'projectType' => ruby_to_camel_case(options[:project_type]),
          'incentiveType' => ruby_to_camel_case(options[:incentive_type]),
          'defaultIncentives' => convert_to_boolean(options[:default_incentives]),
          'customerClasses' => multi_option_handler(options[:customer_classes]),
          'countryCode' => options[:country_code],
          'lseId' => options[:lse_id],
          'state' => options[:state],
          'zipCode' => options[:zip_code],
          'addressString' => options[:address_string],
          'effectiveOn' => format_to_iso8601(options[:effective_on]),
          'fromDate' => format_to_iso8601(options[:from] || options[:from_date]),
          'toDate' => format_to_iso8601(options[:to] || options[:to_date]),
          'isExhausted' => convert_to_boolean(options[:is_exhausted])
        }.delete_if{ |k,v| v.nil? }.
          merge( incentive_params(options) ).
          merge( search_params(options) ).
          merge( pagination_params(options) )
        params.merge(
          options.select{ |k,v| params[ruby_to_camel_case(k)].nil? }.
          map{ |k,v| [ruby_to_camel_case(k), v] }.
          to_h
        )
      end

      def incentive_params(options)
        {
          'populateDetails' => convert_to_boolean(options[:populate_details]),
          'populateDocuments' => convert_to_boolean(options[:populate_documents])
        }.delete_if{ |k,v| v.nil? }
      end

    end
  end
end

