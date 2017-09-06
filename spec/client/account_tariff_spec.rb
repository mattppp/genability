require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "account_tariff.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".add_account_tariff" do

        it "adds a new account tariff" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @account_tariff = @client.add_account_tariff(@account.account_id, :master_tariff_id => 522)
          @account_tariff.master_tariff_id.should == 522
          @client.delete_account(@account.account_id)
        end

      end

      context ".upsert_account_tariff" do

        it "adds a new account tariff" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @account_tariff = @client.upsert_account_tariff(@account.account_id, :master_tariff_id => 522)
          @account_tariff.master_tariff_id.should == 522
          @client.delete_account(@account.account_id)
        end

      end

      context ".delete_account_tariff" do

        it "deletes an account" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @account_tariff = @client.upsert_account_tariff(@account.account_id, :master_tariff_id => 522)
          @client.delete_account_tariff(@account.account_id).status.should == 'success'
          @client.delete_account(@account.account_id)
        end

      end

      context ".add_provider_account_tariff" do

        it "adds a new account tariff" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @account_tariff = @client.add_provider_account_tariff(@account.provider_account_id, :master_tariff_id => 522)
          @account_tariff.master_tariff_id.should == 522
          @client.delete_account(@account.account_id)
        end

      end

      context ".upsert_provider_account_tariff" do

        it "adds a new account tariff" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @account_tariff = @client.upsert_provider_account_tariff(@account.provider_account_id, :master_tariff_id => 522)
          @account_tariff.master_tariff_id.should == 522
          @client.delete_account(@account.account_id)
        end

      end

      context ".delete_provider_account_tariff" do

        it "deletes an account" do
          @account = @client.upsert_account(:provider_account_id => 'account_test')
          @account_tariff = @client.upsert_account_tariff(@account.account_id, :master_tariff_id => 522)
          @client.delete_provider_account_tariff(@account.provider_account_id).status.should == 'success'
          @client.delete_account(@account.account_id)
        end

      end

    end
  end
end

