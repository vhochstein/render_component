require 'components'
require 'action_dispatch/middleware/flash'
ActionController::Base.send :include, Components
