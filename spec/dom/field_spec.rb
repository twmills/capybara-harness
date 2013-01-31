require 'spec_helper'

describe Capybara::Harness::Dom::Field do

  include Capybara::DSL
  include Capybara::RSpecMatchers

  before do
    visit('/form')
  end

  describe "#fill" do
    context "when only name is specified" do
      it "fills in the field" do
        field = Capybara::Harness::Dom::Field.new(:zipcode)
        field.fill({ zipcode: '12345'})
        page.find_field('Zipcode').value.should == '12345'
      end
    end

    context "when the :label option is specified" do
      it "fills in the field" do
        field = Capybara::Harness::Dom::Field.new(:explanation, label: 'Explanation of Name')
        field.fill({ explanation: 'None'})
        page.find_field('Explanation of Name').value.should == 'None'
      end
    end

    context "when the :as option is specified" do
      describe ":select" do
        it "selects the field" do
          field = Capybara::Harness::Dom::Field.new(:other_title, as: :select, label: 'Other title')
          field.fill({ other_title: 'Miss'})
          page.should have_select('Other title', :selected => 'Miss')
        end

        it "selects multiple values"
      end

      describe ":checkbox" do
        it "checks the box when true" do
          page.uncheck('Terms of Use')
          field = Capybara::Harness::Dom::Field.new(:terms, as: :checkbox, label: 'Terms of Use')
          field.fill({ terms: true })
          page.find_field('Terms of Use').should be_checked
        end

        it "unchecks the box when true" do
          page.check('Terms of Use')
          field = Capybara::Harness::Dom::Field.new(:terms, as: :checkbox, label: 'Terms of Use')
          field.fill({ terms: false })
          page.find_field('Terms of Use').should_not be_checked
        end

        it "checks multiple values"

        it "unchecks multiple values"
      end

      describe ":radio" do
        it "selects the radio option"
      end

      describe ":file" do
        it "fills in the field"
      end
    end

  end


end