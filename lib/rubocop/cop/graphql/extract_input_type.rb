# frozen_string_literal: true

module RuboCop
  module Cop
    module GraphQL
      class ExtractInputType < Cop
        # This cop checks fields on common prefix groups
        #
        # # @example
        #   # good
        #
        #   class UpdateUser < BaseMutation
        #     argument :uuid, ID, required: true
        #     argument :user_attributes, UserAttributesInputType
        #   end
        #
        #   # bad
        #
        #   class UpdateUser < BaseMutation
        #     argument :uuid, ID, required: true
        #     argument :first_name, String, required: true
        #     argument :last_name, String, required: true
        #   end
        #
        include RuboCop::GraphQL::NodePattern

        MSG = "Consider moving arguments to a new input type"

        def on_class(node)
          schema_member = RuboCop::GraphQL::SchemaMember.new(node)

          if (body = schema_member.body)
            arguments = body.select { |node| argument?(node) }

            excess_arguments = arguments.count - cop_config["MaxArguments"]
            if excess_arguments > 0
              add_offense(arguments.last(excess_arguments))
            end
          end
        end
      end
    end
  end
end
