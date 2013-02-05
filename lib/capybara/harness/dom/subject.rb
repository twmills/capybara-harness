module Capybara::Harness::Dom
  class Subject
    include Capybara::DSL

    attr_accessor :dom_reader, :dom_writer, :values

    def initialize(dom_reader, dom_writer, values = {})
      self.dom_reader = dom_reader
      self.dom_writer = dom_writer
      self.values = values
    end

    # Public: Scans the DOM and finds the node that represents the subject's form element and fills it with the supplied
    # values. It also resets the subjects current value hash has with the new values.
    #
    # new_values - The values to fill the form with.
    #
    # Returns nothing of interest.
    def fill_form(new_values = {})
      reset!(new_values)
      dom_writer.fill(values)
    end

    # Public: Returns true if the subject's element is present on the page.
    def on_the_page?
      dom_reader.has_attrs?(self.values)
    end

    def element
      @element ||= dom_reader.find_element(self.values)
    end

    def list
      @list ||= dom_reader.find_list
    end

    def in_the_list?
      return false unless list.has_css?(".#{selector} .#{finder_attr_name}", :text => finder_attr)
      has_attrs?(element(list))
    end

    # Public: Finds and clicks the element's link that is assigned the data attribute for the supplied action. Common actions
    # include :edit or :delete.
    def click_action(action)
      dom_reader.find_element(self.values).find("[data-action='#{action}']").click
    end

    def reset!(new_values = {})
      self.values = values.merge(new_values)
      @element = nil
      @list = nil
    end

  end
end