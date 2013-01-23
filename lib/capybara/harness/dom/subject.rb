module Capybara::Harness::Dom
  class Subject
    include Capybara::DSL

    attr_accessor :selector, :attributes, :finder_attr_name, :values, :form

    def initialize(configuration, values = {})
      self.selector = configuration.selector
      self.finder_attr_name = configuration.finder_attr_name
      self.attributes = configuration.attributes
      self.form = configuration.form
      reset!(values)
    end

    # Public: Returns the value of the finder attribute for this subject.
    def finder_attr
      values[finder_attr_name] || ''
    end

    # Public: Scans the DOM and finds the node that represents the subject.
    def element(root = nil)
      root = root || page
      root.find(".#{selector} .#{finder_attr_name}", :text => finder_attr).find(:xpath, ".//ancestor::*[@class='#{selector}']")
    end

    # Public: Scans the DOM and finds the node that represents the subject's list element.
    def list
      find("##{selector.to_s.pluralize}")
    end

    # Public: Scans the DOM and finds the node that represents the subject's form element and fills it with the supplied
    # values. It also resets the subjects current value hash has with the new values.
    #
    # new_values - The values to fill the form with.
    #
    # Returns nothing of interest.
    def fill_form(new_values = {})
      new_values = HashWithIndifferentAccess.new(new_values)
      form.fill(new_values)
      self.reset!(new_values)
    end

    # Public: Returns true if the subject's element is present on the page.
    def on_the_page?
      has_attrs?(element)
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

    # Public: Finds and clicks the element's link that is assigned the data attribute for the supplied action. Common actions
    # include :edit or :delete.
    def click_action(action)
      element.find("[data-#{selector}-action='#{action}']").click
    end

    private

    def has_attrs?(node)
      attributes.each do |attr_name, attr|
        text = attr.extract_value(values)
        return false unless node.has_css?(".#{attr_name}", :text => text)
      end

      true
    end

    def reset!(subject_values = {})
      self.values = {}
      attributes.each do |name, attribute|
        values[name] = attribute.extract_value(subject_values)
      end
      self.values = HashWithIndifferentAccess.new(self.values.merge(subject_values))
    end
  end
end