module Genability
  class Client

    module UsageProfile

      def add_profile(options = {})
        post("v1/profiles", add_profile_params(options)).results.first
      end

      def upsert_profile(options = {})
        put("v1/profiles", add_profile_params(options)).results.first
      end

      def delete_profile(profile_id)
        delete("v1/profiles/#{profile_id}")
      end

      def delete_provider_profile(provider_profile_id)
        delete("v1/profiles/pid/#{provider_profile_id}")
      end

      def profiles(options = {})
        get("v1/profiles", profiles_params(options)).results
      end

      def profile(profile_id, options = {})
        get("v1/profiles/#{profile_id}", profile_params(options)).results.first
      end

      def provider_profile(provider_profile_id, options = {})
        get("v1/profiles/pid/#{provider_profile_id}", profile_params(options)).results.first
      end

      def add_profile_readings(profile_id, options = {})
        post("v1/profiles/#{profile_id}/readings", add_readings_params(options))
      end

      def update_profile_readings(profile_id, options = {})
        put("v1/profiles/#{profile_id}/readings", add_readings_params(options))
      end

      def add_provider_profile_readings(provider_profile_id, options = {})
        post("v1/profiles/pid/#{provider_profile_id}/readings", add_readings_params(options))
      end

      def update_provider_profile_readings(provider_profile_id, options = {})
        put("v1/profiles/pid/#{provider_profile_id}/readings", add_readings_params(options))
      end

      def upload_csv(file, options = {})
        post("v1/loader/account/up.json", upload_params(file, "text/csv", "csv", options)).results.first
      end

      def upload_green_button(file, options = {})
        post("v1/loader/account/up.json", upload_params(file, "application/xml", "espi", options)).results.first
      end

      alias :add_usage_profile :add_profile
      alias :usage_profiles :profiles
      alias :usage_profile :profile
      alias :add_readings :add_profile_readings
      alias :green_button :upload_green_button

      private

      def add_profile_params(options)
        {
          "accountId" => options[:account_id],
          "providerAccountId" => options[:provider_account_id],
          "providerProfileId" => options[:provider_profile_id],
          "profileName" => options[:profile_name],
          "description" => options[:description],
          "serviceTypes" => multi_option_handler(options[:service_types]),
          "isDefault" => convert_to_boolean(options[:is_default]),
          "sourceId" => ruby_to_camel_case(options[:source_id]),
          "source" => source_params(options[:source]),
          "properties" => properties_params(options[:properties]),
          "readingData" => readings_params(options[:reading_data]),
          "baselineMeasures" => baseline_measures_params(options[:baseline_measures]),
          "groupBy" => convert_to_upcase(options[:group_by])
        }.
        delete_if{ |k,v| v.nil? }
      end

      def profiles_params(options)
        {
          "accountId" => options[:account_id],
          "profileName" => options[:profile_name],
          "serviceTypes" => multi_option_handler(options[:service_types]),
          "isDefault" => convert_to_boolean(options[:is_default]),
          "groupBy" => convert_to_upcase(options[:group_by]),
          "populateIntervals" => convert_to_boolean(options[:populate_intervals])
        }.
        delete_if{ |k,v| v.nil? }.
        merge(pagination_params(options)).
        merge(search_params(options))
      end

      def profile_params(options)
        {
          "fromDateTime" => format_to_iso8601(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_iso8601(options[:to] || options[:to_date_time]),
          "populateReadings" => convert_to_boolean(options[:populate_readings]),
          "populateIntervals" => convert_to_boolean(options[:populate_intervals]),
          "populateBaseline" => convert_to_boolean(options[:populate_baseline]),
          "groupBy" => convert_to_upcase(options[:group_by]),
          "clipBy" => options[:clip_by],
          "fields" => options[:fields]
        }.
        delete_if{ |k,v| v.nil? }
      end

      def add_readings_params(options)
        return nil if options.nil?
        {
          "usageProfileId" => options[:usage_profile_id],
          "providerProfileId" => options[:provider_profile_id],
          "readings" => readings_params(options[:readings]),
        }.
        delete_if{ |k,v| v.nil? }
      end

      def source_params(options)
        return nil if options.nil?
        {
          "sourceId" => options[:source_id],
          "sourceVersion" => options[:source_version]
        }.
        delete_if{ |k,v| v.nil? }
      end

      def readings_params(readings)
        return nil if readings.nil?
        case readings
        when Hash
          [convert_reading(readings)]
        when Array
          readings.map{|r| convert_reading(r)}
        else
          raise Genability::InvalidInput
        end
      end

      def convert_reading(options)
        {
          "fromDateTime" => format_to_iso8601(options[:from] || options[:from_date_time]),
          "toDateTime" => format_to_iso8601(options[:to] || options[:to_date_time]),
          "quantityUnit" => options[:quantity_unit],
          "quantityValue" => options[:quantity_value]
        }.
        delete_if{ |k,v| v.nil? }
      end

      def upload_params(file, format, content_type, options = {})
        {
          "fileData" => Faraday::UploadIO.new(file, content_type),
          "fileFormat" => format
        }
        .merge(add_profile_params(options))
      end

      def baseline_measures_params(baseline_measures)
        return nil if baseline_measures.nil?
        case baseline_measures
        when Hash
          [convert_baseline_measure(baseline_measures)]
        when Array
          baseline_measures.map{|b| convert_baseline_measure(b)}
        else
          raise Genability::InvalidInput
        end
      end

      def convert_baseline_measure(options)
        {
          "i" => options[:i],
          "v" => options[:v],
        }.
        delete_if{ |k,v| v.nil? }
      end

    end
  end
end

