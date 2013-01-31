module Capybara::Harness::Dom
  class Field
    include Capybara::DSL

    attr_accessor :name, :label, :as, :through

    def initialize(name, options = {})
      @name = name.to_sym
      @through = extract_option_as_sym(:through, options)
      @label = options.fetch(:label, name.to_s.titleize)
      @as = options.fetch(:as, :string).to_sym
    end

    def fill(attrs = {})
      value = extract_value(attrs)
      case as
        when :string then
          fill_in(label, :with => value)
        when :select then
          select(value, :from => label)
        when :file
          attach_file(label, value)
        when :radio
          choose(label)
        when :checkbox
          value == true ? check(label) : uncheck(label)
      end
    end

    def through
      @through.to_sym if @through
    end

    private

    def has_attribute?(attrs)
      return attrs[through].has_key?(name) if through && attrs.has_key?(through)
      attrs.has_key?(name)
    end

    def extract_value(attrs)
      attrs = attrs[through] unless through.nil?
      attrs[name.to_sym]
    end

    def extract_option_as_sym(option_name, options)
      option = options.delete(option_name)
      option.nil? ? nil : option.to_sym
    end

  end
end