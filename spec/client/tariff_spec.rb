require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "tariff.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".tariffs" do

        it "should return an array of tariffs" do
          tariffs = @client.tariffs
          tariffs.should be_an Array
        end

        it "should allow searches by lse_id" do
          @client.tariffs(:lse_id => 734).each do |tariff|
            tariff.lse_id.should == 734
          end
        end

        it "should accept a string for customerClass" do
          @client.tariffs(:customer_classes => 'residential').each do |tariff|
            tariff.customer_class.should =~ /RESIDENTIAL/
          end
        end

        it "should accept an array for tariffTypes" do
          @client.tariffs(:tariff_types => ['default', 'alternative']).each do |tariff|
            tariff.tariff_type.should =~ /(DEFAULT)|(ALTERNATIVE)/
          end
        end

      end

      context ".tariff" do

        it "should return a tariff" do
          tariff = @client.tariff(512)
          tariff.should be_a Hashie::Mash
          tariff.master_tariff_id.should == 512
        end

        it "should return a tariff with rates and properties" do
          tariff = @client.tariff(512, { :populate_rates => 'true', :populate_properties => 'true' })
          tariff.should be_a Hashie::Mash
          tariff.properties.count.should > 0
          tariff.rates.count.should > 0
        end

      end

    end

  end
end

