# Rails::Render::Component

Legacy functionality from Rails 1.x and (maybe) 2.x days.
It execute the code in the `controller#action` before rendering the view into a string.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rails-render-component'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rails-render-component

## Usage

Components allow you to call other actions for their rendered response while executing another action. You can either delegate
the entire response rendering or you can mix a partial response in with your other content.

  class WeblogController < ActionController::Base
    # Performs a method and then lets hello_world output its render
    def delegate_action
      do_other_stuff_before_hello_world
      render_component :controller => "greeter",  :action => "hello_world", :params => { :person => "david" }
    end
  end

  class GreeterController < ActionController::Base
    def hello_world
      render :text => "#{params[:person]} says, Hello World!"
    end
  end

The same can be done in a view to do a partial rendering:

  Let's see a greeting:
  <%= render_component :controller => "greeter", :action => "hello_world" %>

It is also possible to specify the controller as a class constant, bypassing the inflector
code to compute the controller class at runtime:

<%= render_component :controller => GreeterController, :action => "hello_world" %>

== When to use components

Components should be used with care. They're significantly slower than simply splitting reusable parts into partials and
conceptually more complicated. Don't use components as a way of separating concerns inside a single application. Instead,
reserve components to those rare cases where you truly have reusable view and controller elements that can be employed
across many applications at once.

So to repeat: Components are a special-purpose approach that can often be replaced with better use of partials and filters.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mathieujobin/render-component.

## Copyright

Copyright (c) 2007      Original creation by David Heinemeier Hansson, released under the MIT license
Copyright (c) 2008      Rebirth by Pratik Naik and Dan Powell
Copyright (c) 2010-2012 Upgrade to Rails 3.x by Volker Hochstein, Jonathan McCoy,
Copyright (c) 2013-2015 Fixes for rails 4.x by Sergio Cambra, Richard Zheng and Mathieu Jobin
Copyright (c) 2020-2021 Fix for Rails 5.0 by Mathieu Jobin
