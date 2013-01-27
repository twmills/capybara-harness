require 'spec_helper'

describe Capybara::Harness::Dom::Reader do
  subject { Capybara::Harness::Dom::Reader.new }

  context 'when adding attributes' do
    it "sets the attribute" do
      subject.attribute :first_name
      subject.attributes.values.first.name.should == :first_name
    end

    context 'and the finder option is set' do
      before { subject.attribute :first_name, finder: true }
      its(:finder_attr_name) { should == :first_name }
    end

    context 'and an evaluation block is supplied' do
      before do
        subject.attribute :first_name, finder: true do
          "value"
        end
      end
      it "sets the evaluation block on the attribute" do
        subject.attributes.values.first.derived_value_block.call([]).should == "value"
      end
    end
  end
end