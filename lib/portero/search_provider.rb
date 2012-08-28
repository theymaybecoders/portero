require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/blank'

module Portero
  module SearchProvider
    module ClassMethods

      def api_not_implemented(klass)
        caller.first.match(/in \`(.+)\'/)
        method_name = $1
        raise InterfaceNotImplementedError.new("#{klass.class.name} needs to implement '#{method_name}'!")
      end

      def requires_option(key)
        required_options << key
      end
    end

    module InstanceMethods

      def initialize(options = {})
        @provider_options = options
        validate_options
      end

      def search(connection, query, latitude, longitude, options = {})
        self.class.api_not_implemented(self)
      end

      def validate_options
        self.class.required_options.each do |key|
          raise MissingRequirementError.new("#{self.class.name} needs an options hash key of '#{key}' to function") unless @provider_options.has_key?(key)
        end
      end

    end

    def self.included(receiver)
      receiver.extend           ClassMethods
      receiver.send :include,   InstanceMethods
      class << receiver
        class_attribute(:required_options)
        self.required_options = []
      end
    end

    class InterfaceNotImplementedError < NoMethodError
    end

    class MissingRequirementError < Exception
    end
  end
end