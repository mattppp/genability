module Genability
  class Client
    module SavingsAnalysis
      def analysis(options = {})
        post("v1/accounts/analysis", analysis_params(options)).results.first
      end

      private

      def analysis_params(options)
        {
          "accountId" => options[:account_id],
          "providerAccountId" => options[:provider_account_id],
          "fromDateTime" => format_to_ymd(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_ymd(options[:to] || options[:to_date_time]),
          "useIntelligentBaselining" => options[:use_intelligent_baselining],
          "populateCosts" => options[:populate_costs],
          "fields" => options[:fields],
          "propertyInputs" => property_inputs_params(options[:property_inputs]),
          "rateInputs" => rate_inputs_params(options[:rate_inputs])
        }.
        delete_if{ |k,v| v.nil? }
      end

      def property_inputs_params(property_inputs)
        return nil if property_inputs.nil?
        case property_inputs
        when Hash
          [convert_property_input(property_inputs)]
        when Array
          property_inputs.map{|p| convert_property_input(p)}
        else
          raise Genability::InvalidInput
        end
      end

      def convert_property_input(options)
        {
          "scenarios" => options[:scenarios],
          "keyName" => ruby_to_camel_case(options[:key_name]),
          "dataValue" => options[:data_value].to_s
        }.
        delete_if{ |k,v| v.nil? }
      end

      def rate_inputs_params(rate_inputs)
        return nil if rate_inputs.nil?
        case rate_inputs
        when Hash
          [convert_rate_input(rate_inputs)]
        when Array
          rate_inputs.map{|p| convert_rate_input(p)}
        else
          raise Genability::InvalidInput
        end
      end

      def convert_rate_input(options)
        {
          "scenarios" => options[:scenarios],
          "chargeType" => options[:charge_type].to_s.upcase,
          "rateName" => options[:rate_name],
          "rateBands" => rate_bands_params(options[:rate_bands])
        }.
        delete_if{ |k,v| v.nil? }
      end

      def rate_bands_params(rate_bands)
        return nil if rate_bands.nil?
        case rate_bands
        when Hash
          [convert_rate_band(rate_bands)]
        when Array
          rate_bands.map{|r| convert_rate_band(r)}
        else
          raise Genability::InvalidInput
        end
      end

      def convert_rate_band(options)
        {
          "rateAmount" => options[:rate_amount],
          "rateUnit" => options[:rate_unit] && options[:rate_unit].to_s.upcase
        }.
        delete_if{ |k,v| v.nil? }
      end

    end
  end
end

