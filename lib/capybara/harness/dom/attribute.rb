module Capybara::Harness::Dom
  class Attribute

    attr_accessor :name, :derived_value_block

    def initialize(name, options = {})
      self.name = name
      self.derived_value_block = options.delete(:derived_value_block)
    end

    def derive_value(values = {})
      if derived_value_block
        derived_value_block.call(values)
      else
        values.fetch(name, "")
      end
    end
  end
end