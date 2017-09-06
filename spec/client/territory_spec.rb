require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "territory.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".territories" do

        it "should return an array of territories" do
          territories = @client.territories(:lse_id => 734)
          territories.should be_an Array
        end

        it "should allow searches by lse_id" do
          @client.territories(:lse_id => 734).each do |territory|
            territory.lse_id.should == 734
          end
        end

        it "should get the territory ID from a zipcode" do
          territories = @client.territories(
                          :lse_id => 734,
                          :zip_code => 94115,
                          :master_tariff_id => 522)
          territories.first.territory_id.should == 3538
        end

      end

      context ".territory" do

        it "should return a territory" do
          territory = @client.territory(3539)
          territory.should be_a Hashie::Mash
          territory.lse_id.should == 734
        end

      end

    end

  end
end

