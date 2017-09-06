require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "profile.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".add_profile" do

        it "creates a new profile" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @profile = @client.add_profile(:account_id => @account.account_id)
          @profile.account_id.should == @account.account_id
          @client.delete_profile(@profile.profile_id)
        end

      end

      context ".upsert_profile" do

        it "upserts a profile" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.upsert_profile(
            :account_id => @account.account_id,
            :provider_profile_id => 'upsert_profile_test')
          @profile.account_id.should == @account.account_id
          @profile.provider_profile_id.should == 'upsert_profile_test'
          @client.delete_profile(@profile.profile_id)
        end

      end

      context ".delete_profile" do

        it "deletes a profile" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.add_profile(:account_id => @account.account_id)
          @client.delete_profile(@profile.profile_id).status.should == 'success'
        end

      end

      context ".delete_provider_profile" do

        it "deletes a provider profile" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.upsert_profile(
            :account_id => @account.account_id,
            :provider_profile_id => 'delete_profile_test')
          @result = @client.delete_provider_profile(@profile.provider_profile_id)
          @result.status.should == 'success'
        end

      end

      context ".profiles" do

        it "lists profiles" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.add_profile(:account_id => @account.account_id)
          @client.profiles(:account_id => @account.account_id).count.should >= 1
          @client.delete_profile(@profile.profile_id)
        end

      end

      context ".profile" do

        it "returns a profile" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.add_profile(:account_id => @account.account_id)
          @client.profile(@profile.profile_id).profile_id.should == @profile.profile_id
          @client.delete_profile(@profile.profile_id)
        end

      end

      context ".provider_profile" do

        it "returns a provider profile" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.upsert_profile(
            :account_id => @account.account_id,
            :provider_profile_id => 'provider_profile_test')
          @found_profile = @client.provider_profile(@profile.provider_profile_id)
          @found_profile.profile_id.should == @profile.profile_id
          @client.delete_profile(@profile.profile_id)
        end

      end

      context ".add_profile_readings" do

        it "adds profile readings" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.add_profile(:account_id => @account.account_id)
          @readings = @client.add_profile_readings(@profile.profile_id, :readings => test_readings)
          @readings.status.should == "success"
          @found_profile = @client.profile(@profile.profile_id, :group_by => "month")
          @found_profile.reading_data_summaries.count.should == 1
          @found_profile.reading_data_summaries.first.number_of_readings.should > 0
          @found_profile.intervals.total_count.should > 0
          @client.delete_profile(@profile.profile_id)
        end

      end

      context ".update_profile_readings" do

        it "updates profile readings" do
          @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
          @profile = @client.add_profile(:account_id => @account.account_id)
          @readings = @client.update_profile_readings(@profile.profile_id, :readings => test_readings)
          @readings.status.should == "success"
          @found_profile = @client.profile(@profile.profile_id, :group_by => "month")
          @found_profile.reading_data_summaries.count.should == 1
          @found_profile.reading_data_summaries.first.number_of_readings.should > 0
          @client.delete_profile(@profile.profile_id)
        end

      end

      # context ".add_provider_profile_readings" do

      #   it "adds provider profile readings" do
      #     @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
      #     @profile = @client.upsert_profile(
      #       :account_id => @account.account_id,
      #       :provider_profile_id => 'add_provider_profile_readings_test')
      #     @readings = @client.add_provider_profile_readings(@profile.provider_profile_id, :readings => test_readings)
      #     @readings.status.should == "success"
      #     @found_profile = @client.profile(@profile.profile_id, :group_by => "month")
      #     @found_profile.reading_data_summaries.count.should == 1
      #     @found_profile.reading_data_summaries.first.number_of_readings.should > 0
      #     @client.delete_profile(@profile.profile_id)
      #   end

      # end

      # context ".update_provider_profile_readings" do

      #   it "updates provider profile readings" do
      #     @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
      #     @profile = @client.upsert_profile(
      #       :account_id => @account.account_id,
      #       :provider_profile_id => 'update_provider_profile_readings_test')
      #     @readings = @client.update_provider_profile_readings(@profile.provider_profile_id, :readings => test_readings)
      #     @readings.status.should == "success"
      #     @found_profile = @client.profile(@profile.profile_id, :group_by => "month")
      #     @found_profile.reading_data_summaries.count.should == 1
      #     @found_profile.reading_data_summaries.first.number_of_readings.should > 0
      #     @client.delete_profile(@profile.profile_id)
      #   end

      # end

      # context ".upload_csv" do

      #   it "should accept properly formatted CSV files" do
      #     @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
      #     @profile = @client.add_profile(:account_id => @account.account_id)
      #     @result = @client.upload_csv(
      #       File.expand_path("../../fixtures/sample.csv", __FILE__),
      #       :profile_id => @profile.profile_id
      #     )
      #     @result.status.should == "success"
      #     @client.delete_profile(@profile.profile_id)
      #   end

      # end

      # context ".upload_green_button" do

      #   it "should accept properly formatted XML files" do
      #     @account = @client.upsert_account(:provider_account_id => 'ruby_test_account')
      #     @profile = @client.add_profile(:account_id => @account.account_id)
      #     @result = @client.upload_green_button(
      #       File.expand_path("../../fixtures/greenbutton.xml", __FILE__),
      #       :profile_id => @profile.profile_id
      #     )
      #     @result.status.should == "success"
      #     @client.delete_profile(@profile.profile_id)
      #   end

      # end

    end
  end

  def test_readings
    [
      {
        :from => "2011-08-01T22:30:00.000-0700",
        :to => "2011-08-01T22:45:00.000-0700",
        :quantity_unit => "kWh",
        :quantity_value => 220
      }
    ]
  end
end

