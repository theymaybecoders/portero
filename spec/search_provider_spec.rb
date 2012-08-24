require 'spec_helper'

describe Portero::SearchProvider do

  before do
    @conn = Faraday.new do |builder|
      builder.adapter Faraday.default_adapter
    end

    @provider_class = Class.new do
      include Portero::SearchProvider
    end
  end

  describe "requires_option" do

    it "should add the passed symbols to the required_options array" do
      @provider_class.requires_option(:key)
      @provider_class.required_options.should == [:key]
      @provider_class.requires_option(:key_again)
      @provider_class.required_options.should == [:key, :key_again]
    end

  end

  describe "validate_options" do

    it "should raise an error if the required keys aren't present on invocation" do
      @provider_class.requires_option(:key)
      -> {@provider_class.new}.should raise_error(Portero::SearchProvider::MissingRequirementError, /needs an options hash key of 'key' to function/)
    end

    it "should not raise an error if all required keys are present on invocation" do
      @provider_class.requires_option(:key)
      -> {@provider_class.new(key: "blah")}.should_not raise_error(Portero::SearchProvider::MissingRequirementError, /needs an options hash key of 'key' to function/)
    end
  end

  describe 'interface' do

    it 'should raise an error if the search method is not implemented' do
      -> {@provider_class.new.search(@conn, "blah", 30, -90)}.should raise_error(Portero::SearchProvider::InterfaceNotImplementedError, /needs to implement 'search'/)
    end

  end
end