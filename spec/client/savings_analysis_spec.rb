require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "analysis.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".savings_analysis" do

        it "runs a savings analysis" do
          account = build_account(@client)
          usage_profile = build_usage_profile(@client, account)
          solar_profile = build_solar_profile(@client, account)
          analysis = @client.analysis({
            :account_id => account.account_id,
            :from_date_time => "2016-01-01",
            :use_intelligent_baselining => true,
            :populate_costs => true,
            :fields => :ext,
            :property_inputs => [
              {
                :scenarios => "before",
                :key_name => :master_tariff_id,
                :data_value => 522
              },
              {
                :scenarios => "after",
                :key_name => :master_tariff_id,
                :data_value => 525
              },
              {
                :scenarios => "before,after",
                :key_name => :provider_profile_id,
                :data_value => usage_profile.provider_profile_id
              },
              {
                :scenarios => "solar,after",
                :key_name => :provider_profile_id,
                :data_value => solar_profile.provider_profile_id
              }
            ],
            :rate_inputs => [{
              :scenarios => "solar",
              :charge_type => :fixed_price,
              :rate_bands => [{
                :rate_amount => 100.00
              }]
            }]
          })
          analysis.summary.net_avoided_cost.should > 0
          @client.delete_profile(usage_profile.profile_id)
          @client.delete_profile(solar_profile.profile_id)
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

  def build_usage_profile(client, account)
    client.upsert_profile(
      :account_id => account.account_id,
      :provider_profile_id => 'test_usage_profile',
      :profile_name => 'Electricity Usage',
      :service_types => :electricity,
      :source_id => :reading_entry,
      :is_default => true,
      :reading_data => [
        {
          :from => "2016-01-01T00:00:00.000-0800",
          :to => "2016-02-01T00:00:00.000-0800",
          :quantity_unit => "kWh",
          :quantity_value => 1000
        }
      ]
    )
  end

  def build_solar_profile(client, account)
    client.upsert_profile(
      :account_id => account.account_id,
      :provider_profile_id => 'test_solar_profile',
      :profile_name => 'Solar Production',
      :service_types => :solar_pv,
      :source_id => :reading_entry,
      :reading_data => [
        {
          :from => "2016-01-01T00:00:00.000-0800",
          :to => "2016-02-01T00:00:00.000-0800",
          :quantity_unit => "kWh",
          :quantity_value => 800
        }
      ]
    )
  end
end

