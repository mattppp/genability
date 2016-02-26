require File.expand_path('../../spec_helper', __FILE__)

describe Genability::Client, vcr: true do

  Genability::Configuration::VALID_FORMATS.each do |format|

    context "account.#{format}" do

      before(:all) do
        @options = {:format => format}.merge(configuration_defaults)
        @client = Genability::Client.new(@options)
      end

      context ".add_account" do

        it "creates a new account" do
          @account = @client.add_account(:account_name => 'Ruby Add Account Test')
          @account.account_name.should == 'Ruby Add Account Test'
          @client.delete_account(@account.account_id)
        end

      end

      context ".upsert_account" do

        it "upserts an account" do
          @account = @client.upsert_account(
            :provider_account_id => 'upsert_account_test',
            :account_name => 'Ruby Upsert Account Test')
          @account.provider_account_id.should == 'upsert_account_test'
          @account.account_name.should == 'Ruby Upsert Account Test'
          @client.delete_account(@account.account_id)
        end

      end

      context ".delete_account" do

        it "deletes an account" do
          @account = @client.add_account(:account_name => 'Ruby Delete Account Test')
          @client.delete_account(@account.account_id).status.should == 'success'
        end

      end

      context ".accounts" do

        it "returns a list of accounts" do
          @account = @client.add_account(:account_name => 'Ruby Accounts Test')
          @account.account_name.should == 'Ruby Accounts Test'
          @client.accounts(:search => 'Ruby Accounts Test').count.should == 1
          @client.delete_account(@account.account_id)
        end

      end

      context ".account" do

        it "returns an account" do
          @account = @client.add_account(:account_name => 'Ruby Account Test')
          @client.account(@account.account_id).account_name.should == 'Ruby Account Test'
          @client.delete_account(@account.account_id)
        end

      end

      context ".provider_account" do

        it "returns an account" do
          @account = @client.upsert_account(
            :provider_account_id => 'provider_account_test',
            :account_name => 'Ruby Provider Account Test')
          @found_account = @client.provider_account(@account.provider_account_id)
          @found_account.account_name.should == 'Ruby Provider Account Test'
          @client.delete_account(@account.account_id)
        end

      end

    end
  end
end

