# frozen_string_literal: true

require 'render_component/components'
require 'action_controller'
require 'action_dispatch/middleware/flash'
require_relative "component/version"
require_relative "../../render_component/components"

ActionController::Base.send :include, RenderComponent::Components

module Rails
  module Render
    module Component
      class Error < StandardError; end
      # Your code goes here...
    end
  end
end
