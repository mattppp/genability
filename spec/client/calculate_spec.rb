require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "calculate.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".calculate_metadata" do

        it "returns the inputs required to use the calculate method" do
          metadata = @client.calculate_metadata(512,
            :from_date_time => Time.parse("2016-01-01T00:00:00-0500"),
            :to_date_time => Time.parse("2016-01-02T00:00:00-0500"),
            "connectionType" => "Primary Connection",
            "cityLimits" => "Inside"
          )
          metadata.count.should == 3
          metadata.find { |m| m.key_name == "consumption" }.unit.should == "kWh"
        end

      end

      context ".calculate" do

        it "calculates the total cost" do
          calc = @client.calculate(512,
            :from_date_time => Time.parse("2016-01-01T00:00:00-0800"),
            :to_date_time => Time.parse("2016-01-01T01:00:00-0800"),
            :tariff_inputs => [
              {
                :key_name => :consumption,
                :from_date_time => "2016-01-01T00:00:00-0800",
                :to_date_time => "2016-01-01T00:15:00-0800",
                :data_value => 2.2,
                :unit => "kWh"
              },
              {
                :key_name => :consumption,
                :from_date_time => "2016-01-01T00:15:00-0800",
                :to_date_time => "2016-01-01T00:30:00-0800",
                :data_value => 1.3,
                :unit => "kWh"
              },
              {
                :key_name => :consumption,
                :from_date_time => "2016-01-01T00:30:00-0800",
                :to_date_time => "2016-01-01T00:45:00-0800",
                :data_value => 0.6,
                :unit => "kWh"
              },
              {
                :key_name => :consumption,
                :from_date_time => "2016-01-01T00:45:00-0800",
                :to_date_time => "2016-01-01T01:00:00-0800",
                :data_value => 2.1,
                :unit => "kWh"
              },
              {
                :key_name => :city_limits,
                :from_date_time => "2016-01-01T00:00:00-0800",
                :to_date_time => "2016-01-01T01:00:00-0800",
                :data_value => "Inside"
              },
              {
                :key_name => :connection_type,
                :from_date_time => "2016-01-01T00:00:00-0800",
                :to_date_time => "2016-01-01T01:00:00-0800",
                :data_value => "Primary"
              }
            ],
            :rate_inputs => [
              {
                :rate_group_name => "Taxes",
                :rate_name => "Utility Users Tax",
                :from_date_time => "2016-01-01",
                :to_date_time => "2016-01-02",
                :charge_type => :tax,
                :rate_bands => [
                  {
                    :rate_amount => 0.075,
                    :rate_unit => :percentage
                  }
                ]
              }
            ]
          )

          calc.tariff_name.should == "Residential"
          calc.items.first.rate_name.should == "Basic Service Charge"
        end

        it "does not allow invalid tariff inputs" do
          lambda do
            @client.calculate(512,
              :from_date_time => Time.parse("2016-01-01T00:00:00-0800"),
              :to_date_time => Time.parse("2016-01-01T01:00:00-0800"),
              :tariff_inputs => "InvalidTariffInput")
          end.should raise_error(Genability::InvalidInput)
        end

      end

    end

  end

  def build_account(client)
    account = @client.upsert_account(
      :provider_account_id => 'ruby_test_account',
      :address => { :address_string => "94703" }
    )
  end
end

