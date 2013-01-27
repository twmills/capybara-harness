module Capybara::Harness::Dom
  class Writer
    attr_accessor :name, :fields

    def initialize
      self.fields = []
    end

    def field(*args)
      options = args.last.is_a?(Hash) ? args.pop : {}

      args.each do |field_name|
        fields << Capybara::Harness::Dom::Field.new(options.merge(:name => field_name))
      end
    end

    def fill(attrs = {})
      fields.each { |f| f.fill(attrs) }
    end

  end
end