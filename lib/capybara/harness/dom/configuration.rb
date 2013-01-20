module Capybara::Harness::Dom
  class Configuration

    attr_accessor :selector, :finder_attr_name, :attributes, :form

    def initialize(klass)
      self.selector = klass.name.split('::').last.gsub("OnPage", '').underscore
      self.attributes = {}
    end

    def add_attribute(name, options = {})
      self.finder_attr_name = name.to_sym if options.has_key?(:finder) && options[:finder] == true
      self.attributes[name] = Capybara::Dom::Attribute.new(name, options)
    end

    def set_form(name = nil, block = nil)
      form = Capybara::Dom::Form.new(name)
      block.call(form) unless block.nil?
      self.form = form
    end

  end
end