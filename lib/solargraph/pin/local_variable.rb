# frozen_string_literal: true

module Solargraph
  module Pin
    class LocalVariable < BaseVariable
      include Localized

      def initialize assignment: nil, presence: nil, **splat
        super(**splat)
        @assignment = assignment
        @presence = presence
      end

      def try_merge! pin
        return false unless super
        @presence = pin.presence
        true
      end

      # @param api_map [ApiMap]
      def typify api_map
        runtime_type = infer_type_from_runtime api_map.runtime_param_types
        if !runtime_type.undefined?
          runtime_type
        else
          super
        end
      end

      # @param runtime_param_types [Hash{String => Array<String>}]
      # @return [ComplexType]
      def infer_type_from_runtime runtime_param_types
        # TODO: (Nigel) account for generated things?
        types = runtime_param_types["#{closure.path}%#{name}"]
        return ComplexType.new if types.nil? || types.empty?
        Solargraph.logger.info \
          "infer_type_from_runtime(#{closure.path}%#{name}) --> #{types}"
        ComplexType.try_parse(*types)
      end
    end
  end
end
