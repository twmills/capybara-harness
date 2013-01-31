module Capybara::Harness::Dom
  class Field
    include Capybara::DSL

    attr_accessor :name, :label, :data_type, :through
    attr_accessor :name, :label, :as, :through

    def initialize(options = {})
      self.name = options.delete(:name)
      self.label = options.fetch(:label, name.to_s.titleize)
      self.through = options.delete(:through)
      @as = options.fetch(:as, :string).to_sym
    end

    def fill(attrs = {})
      value = extract_value(attrs)
      case as
        when :string then
          fill_in(label, :with => value)
        when :select then
          select(value, :from => label)
      end
    end

    def through
      @through.to_sym if @through
    end

    def name
      @name.to_sym
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

  end
end