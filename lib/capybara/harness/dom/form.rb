module Capybara::Harness::Dom
  class Form
    attr_accessor :name, :elements

    def initialize(name = nil)
      self.name = name
      self.elements = []
    end

    def field(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      args.each do |field_name|
        elements << Capybara::Harness::Dom::Field.new(options.merge(:name => field_name))
      end
    end

    def fieldset(name = nil, &block)
      fieldset = Capybara::Harness::Dom::FieldSet.new(name)
      block.call(fieldset)
      elements << fieldset
    end

    def fill(attrs = {})
      elements.each { |e| e.fill(attrs) }
    end

  end
end