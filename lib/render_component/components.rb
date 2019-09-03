module RenderComponent
  module Components
    module MethodsToPrepend
      def session
        if component_request?
          @parent_controller.session
        else
          @_request.session
        end
      end

      def flash(refresh = false) #:nodoc:
        if @component_flash.nil? || refresh
          @component_flash =
            if defined?(@parent_controller)
              @parent_controller.flash
            elsif session['flash'].class == String
              warn "WARNING: something, somehow, has replaced the flash by a inspect.to_s output. >>>#{session['flash']}<<<"
              session['flash'] = ActionDispatch::Flash::FlashHash.new
            else
              session['flash'] ||= ActionDispatch::Flash::FlashHash.new
            end
        end
        @component_flash
      end
    end

    def self.included(base) #:nodoc:
      base.class_eval do
        include InstanceMethods
        extend ClassMethods
        helper HelperMethods

        # If this controller was instantiated to process a component request,
        # +parent_controller+ points to the instantiator of this controller.
        attr_accessor :parent_controller
        alias_method :component_request?, :parent_controller
      end

      base.prepend(MethodsToPrepend)
    end

    module ClassMethods
      # Track parent controller to identify component requests
      def process_with_components(request, action, parent_controller = nil) #:nodoc:
        controller = new
        controller.parent_controller = parent_controller
        controller.dispatch(action, request, make_response!(request))
      end
    end

    module HelperMethods
      def render_component(options)
        controller.send(:render_component_into_view, options)
      end
    end

    module InstanceMethods

      protected
        def response_redirect(response)
          if response.respond_to?(:to_path)
            response.to_path
          elsif response.is_a?(ActionDispatch::Response)
            response.redirect_url
          end
        end

        # Renders the component specified as the response for the current method
        def render_component(options) #:doc:
          component_logging(options) do
            response = component_response(options, true)[2]
            redirect_url = response_redirect(response)
            if redirect_url
              redirect_to response.redirect_url
            else
              render :html => response.body.html_safe, :status => response.status
            end
          end
        end

        # Returns the component response as a string
        def render_component_into_view(options) #:doc:
          component_logging(options) do
            response = component_response(options, true)[2]
            redirected = response_redirect(response)
            if redirected
              if redirected =~ %r{://}
                location = URI.parse(redirected)
                redirected = location.query ? "#{location.path}?#{location.query}" : location.path
              end
              render_component_into_view(Rails.application.routes.recognize_path(redirected, { :method => nil }))
            else
              response.body.html_safe
            end
          end
        end

      private
        def component_response(options, reuse_response)
          options[:controller] = options[:controller].to_s if options[:controller] && options[:controller].is_a?(Symbol)
          klass = component_class(options)
          component_request  = request_for_component(klass.controller_path, options)
          # needed ???
          #if reuse_response
            #component_request.env["action_controller.instance"].instance_variable_set :@_response, request.env["action_controller.instance"].instance_variable_get(:@_response)
          #end
          klass.process_with_components(component_request, options[:action], self)
        end

        # determine the controller class for the component request
        def component_class(options)
          if controller = options[:controller]
            controller.is_a?(Class) ? controller : "#{controller.to_s.camelize}Controller".constantize
          else
            self.class
          end
        end

        # Create a new request object based on the current request.
        # NOT IMPLEMENTED FOR RAILS 3 SO FAR: The new request inherits the session from the current request,
        # bypassing any session options set for the component controller's class
        def request_for_component(controller_path, options)
          if options.is_a? Hash
            old_style_params = options.delete(:params)
            options.merge!(old_style_params) unless old_style_params.nil?

            request_params = options.symbolize_keys
            request_env = {}

            request.env.select {|key, value| key == key.upcase || key == 'rack.input'}.each {|item| request_env[item[0]] = item[1]}

            request_env['REQUEST_URI'] = url_for(options)
            request_env["PATH_INFO"] = url_for(options.merge(:only_path => true))
            request_env["action_dispatch.request.symbolized_path_parameters"] = request_params
            request_env["action_dispatch.request.parameters"] = request_params.symbolize_keys
            request_env["action_dispatch.request.path_parameters"] = Hash[request_params.select{|key, value| [:controller, :action].include?(key)}].symbolize_keys
            request_env["warden"] = request.env["warden"] if (request.env.has_key?("warden"))
            component_request = ActionDispatch::Request.new(request_env)

            # its an internal request request forgery protection has to be disabled
            # because otherwise forgery detection might raise an error
            component_request.instance_eval do
              def forgery_whitelisted?
                true
              end
            end
            component_request
          else
            request
          end
        end

        def component_logging(options)
          if logger
            logger.info "Start rendering component (#{options.inspect}): "
            result = yield
            logger.info "\n\nEnd of component rendering"
            result
          else
            yield
          end
        end
    end
  end
end
