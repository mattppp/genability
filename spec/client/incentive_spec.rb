require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "incentive.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".incentives" do

        it "should return an array of incentives" do
          incentives = @client.incentives
          incentives.should be_an Array
        end

        it "should allow searches by project_type" do
          @client.incentives(:project_type => "solar_pv").each do |incentive|
            incentive.project_type.should == "solarPv"
          end
        end

        it "should allow searches by incentive_type" do
          @client.incentives(:incentive_type => "rebate").each do |incentive|
            incentive.incentive_type.should == "rebate"
          end
        end

        it "should allow searches by customer_classes" do
          @client.incentives(:customer_classes => 'residential').each do |incentive|
            incentive.customer_class.should =~ /RESIDENTIAL/
          end
        end

      end

      context ".incentive" do

        it "should return an incentive" do
          incentive = @client.incentive(3163700)
          incentive.should be_a Hashie::Mash
          incentive.master_incentive_id.should == 3163700
        end

        it "should return an incentive with applicabilities" do
          incentive = @client.incentive(3163700, { :populate_applicabilities => 'true' })
          incentive.should be_a Hashie::Mash
          incentive.applicabilities.count.should > 0
        end

      end

    end

  end
end

