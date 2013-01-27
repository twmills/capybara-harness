module Capybara::Harness::Dom
  class Reader
    include Capybara::DSL

    attr_accessor :attributes, :finder_attr_name, :name

    def initialize
      self.attributes = {}
    end

    def attribute(name, options = {}, &block)
      self.finder_attr_name = name.to_sym if options.delete(:finder)
      options.merge!(:derived_value_block => block)
      attributes[name] = Capybara::Harness::Dom::Attribute.new(name, options)
    end

    # Public: Scans the DOM and finds the node that represents the subject.
    def find_element(values = {})
      page.find(".#{name} .#{finder_attr_name}", :text => finder_attr.derive_value(values)).find(:xpath, ".//ancestor::*[@class='#{name}']")
    end

    # Public: Scans the DOM and finds the node that represents the subject's list element.
    def find_list
      find("##{selector.to_s.pluralize}")
    end

    def find_element_through_list(values = {})
      find_list.find_element(values)
    end

    # Public: Returns true if the subject's element is in the page's subject list.
    def in_the_list?
      return false unless list.has_css?(".#{selector} .#{finder_attr_name}", :text => finder_attr)
      has_attrs?(element(list))
    end

    # Public: Returns true if the subject's element is located first in its list.
    def first_in_the_list?
      node = list.first(".#{selector}")
      return false if node.nil?
      has_attrs?(node)
    end

    # Public: Returns true if the subject's element is located last in its list.
    def last_in_the_list?
      node = list.all(".#{selector}").last
      return false if node.nil?
      has_attrs?(node)
    end

    def has_attrs?(values = {})
      node = find_element(values)
      attributes.each do |attr_name, attr|
        text = attr.derive_value(values)
        return false unless node.has_css?(".#{attr_name}", :text => text)
      end

      true
    end

    private

    # Private: Returns the value of the finder attribute for this subject.
    def finder_attr
      attributes[finder_attr_name]
    end


  end
end