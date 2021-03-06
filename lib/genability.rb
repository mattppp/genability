require 'mashie_extensions'
require 'genability/configuration'
require 'genability/connection'
require 'genability/request'
require 'genability/api'
require 'genability/error'
require 'genability/client'

module Genability
  extend Configuration

  # Alias for Genability::Client.new
  #
  # @return [Genability::Client]
  def self.client(options={})
    Genability::Client.new(options)
  end

  # Delegate to Genability::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Genability::Client
  def self.respond_to?(*several_variants)
    return client.respond_to?(*several_variants) || super
  end

end

