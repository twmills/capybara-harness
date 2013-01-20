require 'active_support/core_ext/class'
require 'spec/support/capybara/dom/configuration'
require 'forwardable'

class Capybara::Harness::DomHarness

  extend Forwardable
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  attr_accessor :subject

  def_delegators :subject,
                 :selector,
                 :element,
                 :list,
                 :on_the_page?,
                 :in_the_list?,
                 :last_in_the_list?,
                 :first_in_the_list?,
                 :fill_form,
                 :click_action

  def initialize(values = {})
    self.subject = Capybara::Dom::Subject.new(self.class.configuration, values)
    create_aliases!
  end

  def self.configuration
    @configuration = Capybara::Dom::Configuration.new(self) unless @configuration
    @configuration
  end

  def self.dom_selector(name)
    self.configuration.selector = name
  end

  def self.define_form(name = nil, &block)
    self.configuration.set_form(name, block)
  end

  def self.dom_attr(name, options = {})
    self.configuration.add_attribute(name, options)
  end

  private

  def create_aliases!
    singleton = class << self;
      self
    end

    singleton.send(:alias_method, selector, element)
    singleton.send(:alias_method, "#{selector}_list", list)
  end

end