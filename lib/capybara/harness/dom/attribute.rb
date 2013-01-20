module Capybara::Harness::Dom
  class Attribute
    include Capybara::DSL

    attr_accessor :name, :contents

    def initialize(name, options = {})
      self.name = name
      self.contents = options.delete(:contents)
    end

    def visible?(values)

    end

    def extract_value(values)
      values = HashWithIndifferentAccess.new(values)
      if contents
        contents.call(values)
      else
        values[name].to_s
      end
    end
  end
end