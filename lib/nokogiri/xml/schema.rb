# frozen_string_literal: true
module Nokogiri
  module XML
    class << self
      # Parse an XSD schema definition and create a new {Schema} object. This is a convenience
      # method for {Nokogiri::XML::Schema.new}.
      # @see Nokogiri::XML::Schema.new
      #
      # @param input [String, IO] XSD schema definition
      # @param parse_options [Nokogiri::XML::ParseOptions]
      # @return [Nokogiri::XML::Schema]
      def Schema(input, parse_options = ParseOptions::DEFAULT_SCHEMA)
        Schema.new(input, parse_options)
      end
    end

    # Nokogiri::XML::Schema is used for validating XML against an XSD schema definition.
    #
    # @example Determine whether an XML document is valid.
    #   schema = Nokogiri::XML::Schema(File.read(XSD_FILE))
    #   doc = Nokogiri::XML(File.read(XML_FILE))
    #   schema.valid?(doc) # Boolean
    #
    # @example Validate an XML document against a Schema, and capture any errors that are found.
    #   schema = Nokogiri::XML::Schema(File.read(XSD_FILE))
    #   doc = Nokogiri::XML(File.read(XML_FILE))
    #   errors = schema.validate(doc) # Array<SyntaxError>
    #
    # @note As of v1.11.0, {Schema} treats inputs as *untrusted* by default, and so external
    #       entities are not resolved from the network (+http://+ or +ftp://+). When parsing a
    #       trusted document, the caller may turn off the +NONET+ option via the {ParseOptions} to
    #       (re-)enable external entity resolution over a network connection.
    #
    #       Previously, documents were "trusted" by default during schema parsing which was counter
    #       to Nokogiri's "untrusted by default" security policy.
    class Schema
      # Array of {SyntaxError}s found when parsing the XSD
      attr_accessor :errors
      # The {Nokogiri::XML::ParseOptions} used to parse the schema
      attr_accessor :parse_options

      # Parse an XSD schema definition and create a new {Schema} object.
      #
      # @param input [String, IO] XSD schema definition
      # @param parse_options [Nokogiri::XML::ParseOptions]
      # @return [Nokogiri::XML::Schema]
      def self.new(input, parse_options = ParseOptions::DEFAULT_SCHEMA)
        from_document(Nokogiri::XML(input), parse_options)
      end

      # Validate +input+ and return any errors that are found.
      #
      # @param input [Nokogiri::XML::Document, String] A parsed document, or a string containing a local filename.
      # @return [Array<SyntaxError>]
      #
      # @example Validate an existing XML::Document +document+, and capture any errors that are found.
      #   schema = Nokogiri::XML::Schema(File.read(XSD_FILE))
      #   errors = schema.validate(document)
      #
      # @example Validate an XML document on disk, and capture any errors that are found.
      #   schema = Nokogiri::XML::Schema(File.read(XSD_FILE))
      #   errors = schema.validate("/path/to/file.xml")
      def validate(input)
        if input.is_a?(Nokogiri::XML::Document)
          validate_document(input)
        elsif File.file?(input)
          validate_file(input)
        else
          raise ArgumentError, "Must provide Nokogiri::XML::Document or the name of an existing file"
        end
      end

      # Validate +input+ and return a Boolean indicating whether the document is valid
      #
      # @param input [Nokogiri::XML::Document, String] A parsed document, or a string containing a local filename.
      # @return [Boolean]
      #
      # @example Validate an existing XML::Document +document+
      #   schema = Nokogiri::XML::Schema(File.read(XSD_FILE))
      #   schema.valid?(document)
      #
      # @example Validate an XML document on disk
      #   schema = Nokogiri::XML::Schema(File.read(XSD_FILE))
      #   schema.valid?("/path/to/file.xml")
      def valid?(input)
        validate(input).length == 0
      end
    end
  end
end
