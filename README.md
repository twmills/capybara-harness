[![Build Status](https://travis-ci.org/[YOUR_GITHUB_USERNAME]/[YOUR_PROJECT_NAME].png)](https://travis-ci.org/twmills/capybara-harness)
[![Code Climate](https://codeclimate.com/github/twmills/capybara-harness.png)](https://codeclimate.com/github/twmills/capybara-harness)

# Capybara::Harness

![alt text](http://upload.wikimedia.org/wikipedia/commons/b/bc/Capybara_harness.jpg "A dignified, harness-wearing capybara")

Capybara::Harness implements a test harness strategy to easily query and manipulate DOM elements as self-contained
objects in the context of feature or acceptance tests.

By pulling redundant behavior out of scenarios and tests (such as filling out and submitting forms, or ensuring a
comment element is visible on the page), the focus moves to the essential steps of the use cases and the intent of
the feature becomes more legible.

## Status

This library is still very much in the baking phase, although I am successfully using it in 2 production projects. I'll
be adding specs in the coming weeks.

## Installation

Add this line to your application's Gemfile:

    gem 'capybara-harness'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-harness

## Usage

First, create a new harness in spec/support/harnesses:

```ruby
class BlogPostHarness < Capybara::Harness::DomHarness
  define_reader :post do |r|
    r.attribute :title, :finder => true
    r.attribute :author do |attrs|
      "#{attrs[:first_name]} #{attrs[:last_name][0][1].}"
    end    
    r.attribute :body
  end

  define_writer do |w|
    w.field :title, :label => 'Blog Post Title'
    w.field :body
  end
end
```

Now in your feature spec, e.g. spec/features/blog_posts_spec.rb, create the new harness and interact with it:

```ruby
scenario "Add blog post" do
    post = BlogPostHarness.new
    
    visit blog_posts_path
    click_link 'Add'
    post.create(attributes_for(:blog_post))
    expect(post).to be_on_the_page
  end
```

## Props

I had been playing with the concept for a while in my acceptance tests, but this thoughtbot article really helped
solidify the concept and highly influenced me:

http://robots.thoughtbot.com/post/35776432958/better-support-with-test-harnesses

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
