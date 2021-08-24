# frozen_string_literal: true
module Nokogiri
  module XML
    class << self
      # Parse a RELAX NG schema definition and create a new {Schema} object. This is a convenience
      # method for {Nokogiri::XML::RelaxNG.new}.
      # @see Nokogiri::XML::RelaxNG.new
      #
      # @param input [String, IO] RELAX NG schema definition
      # @param parse_options [Nokogiri::XML::ParseOptions]
      # @return [Nokogiri::XML::RelaxNG]
      def RelaxNG(input, parse_options = ParseOptions::DEFAULT_SCHEMA)
        RelaxNG.new(input, parse_options)
      end
    end

    ###
    # Nokogiri::XML::RelaxNG is used for validating XML against a RELAX NG schema definition.
    #
    # @example Determine whether an XML document is valid.
    #   schema = Nokogiri::XML::RelaxNG(File.read(RELAX_NG_FILE))
    #   doc = Nokogiri::XML(File.read(XML_FILE))
    #   schema.valid?(doc) # Boolean
    #
    # @example Validate an XML document against a RelaxNG schema, and capture any errors that are found.
    #   schema = Nokogiri::XML::RelaxNG(File.open(RELAX_NG_FILE))
    #   doc = Nokogiri::XML(File.open(XML_FILE))
    #   errors = schema.validate(doc) # Array<SyntaxError>
    #
    # @note RELAX NG input is always treated as *trusted*, meaning that the underlying parsing
    #       libraries *will access network resources*. This is counter to Nokogiri's "untrusted by
    #       default" security policy, but is an unfortunate limitation of the underlying
    #       libraries. Please do not use this class for untrusted schema documents.
    class RelaxNG < Nokogiri::XML::Schema
      # Parse a RELAX NG schema definition and create a new {Schema} object.
      #
      # @param input [String, IO] RELAX NG schema definition
      # @param parse_options [Nokogiri::XML::ParseOptions]
      # @return [Nokogiri::XML::RelaxNG]
      def self.new(input, parse_options = ParseOptions::DEFAULT_SCHEMA)
        from_document(Nokogiri::XML(input), parse_options)
      end
    end
  end
end
