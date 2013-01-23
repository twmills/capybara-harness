module Capybara::Harness::Dom
  class FieldSet
    attr_accessor :name, :fields

    def initialize(name)
      self.name = name
      self.fields = []
    end

    def field(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      args.each do |field_name|
        fields << Capybara::Harness::Dom::Field.new(options.merge(:name => field_name))
      end
    end

    def fill(attrs = {})
      if name
        within("##{name}") { fill_fields(attrs) }
      else
        fill_fields(attrs)
      end
    end

    private

    def fill_fields(attrs)
      fields.each { |f| f.fill(attrs) }
    end
  end
end