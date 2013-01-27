require 'active_support/core_ext/class'
require 'forwardable'

class Capybara::Harness::DomHarness

  extend Forwardable
  include Capybara::DSL

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
    self.subject = Capybara::Harness::Dom::Subject.new(self.class.dom_reader, self.class.dom_writer, values)
    create_aliases!(self.class.dom_reader.name)
  end

  [:reader, :writer].each do |m|
    method_name = "dom_#{m}"
    instance_variable_name = "@#{method_name}"
    class_name = "Capybara::Harness::Dom::#{m.capitalize}"

    define_singleton_method method_name do
      unless instance_variable_get(instance_variable_name)
        instance_variable_set(instance_variable_name, constantize(class_name).new)
      end
      instance_variable_get(instance_variable_name)
    end

    define_singleton_method("define_#{m}") do |name = nil, &block|
      send(method_name).name = name
      block.call(send(method_name)) unless block.nil?
    end
  end

  private

  def self.constantize(camel_cased_word)
    names = camel_cased_word.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end

  def create_aliases!(name)
    singleton = class << self;
      self
    end

    singleton.send(:alias_method, name, :element)
    singleton.send(:alias_method, "#{name}_list".to_sym, :list)
  end

end