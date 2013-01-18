module CSL
  class Style

    # Labels are used for printing the term matching the variable selected
    # with the required variable attribute, which must be set to "locator,
    # "page", or one of the number variables.
    #
    # The term is only rendered if the selected variable is non-empty.
    #
    # If the {Label} is the child of a {Names} node, the parent's variable
    # is used instead of the local attribute.
    class Label < Node

      attr_struct :variable, :form, :plural,
        *Schema.attr(:formatting, :periods)

      has_no_children

      @variables = [:locator, :page].concat(Schema.variables[:number]).freeze

      @terms = Hash.new { |h,k| h[k] = k }

      @terms['number-of-pages'] = 'page'
      @terms['number-of-volumes'] = 'volume'
      @terms['chapter-number'] = 'chapter'
      @terms['collection-number'] = 'collection'

      class << self
        # @!attribute [r] variables
        # @return [Array<Symbol>] a list of valid label variable values
        attr_reader :variables

        # @!attribute [r] terms
        # @return [Hash<String, String>] a cache for variable-term mapping
        attr_reader :terms
      end

      def has_variable?
        return parent.has_variable? if names_label?
        attribute?(:variable)
      end

      # The value of the node's variable attribute. If the {Label}
      # is the child of a {Names} node, returns the parent's variable
      # attribute instead.
      #
      # @return [String] the value of the node's variable attribute
      def variable
        return parent.variable if name_label?
        attributes[:variable]
      end

      Label.variables.each do |type|
        pattern = Regexp.new("^#{type}", true)

        define_method("#{type}?".tr('-', '_')) do
          variable.to_s =~ pattern
        end
      end

      def always_pluralize?
        attributes[:plural].to_s =~ /^always$/i
      end

      def never_pluralize?
        attributes[:plural].to_s =~ /^never$/i
      end

      # @return [Boolean] whether or not the {Label} is inside a {Names} node
      def names_label?
        parent.is_a?(Names)
      end
      alias name_label? names_label?

      def term
        Label.terms[variable]
      end
    end

  end
end