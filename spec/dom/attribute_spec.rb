require 'spec_helper'

describe Capybara::Harness::Dom::Attribute do

  let(:values) { { first_name: 'John', last_name: 'Doe' } }

  context 'when no derived value is provided' do
    subject { Capybara::Harness::Dom::Attribute.new(:first_name) }

    it "returns the value from the supplied array" do
      subject.derive_value(values).should == 'John'
    end

    it "returns an empty string when there is no matching value" do
      subject.derive_value({ color: 'orange'}).should == ''
    end
  end

  context 'when an evaluation block is provided' do
    subject { Capybara::Harness::Dom::Attribute.new(:name, derived_value_block: ->(attrs){ "#{attrs[:first_name]} #{attrs[:last_name]}"}) }

    it "returns the value from the supplied array" do
      subject.derive_value(values).should == 'John Doe'
    end
  end

end