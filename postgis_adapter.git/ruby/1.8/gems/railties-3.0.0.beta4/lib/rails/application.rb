require 'active_support/core_ext/hash/reverse_merge'
require 'fileutils'
require 'rails/plugin'
require 'rails/engine'

module Rails
  # In Rails 3.0, a Rails::Application object was introduced which is nothing more than
  # an Engine but with the responsibility of coordinating the whole boot process.
  #
  # Opposite to Rails::Engine, you can only have one Rails::Application instance
  # in your process and both Rails::Application and YourApplication::Application
  # points to it.
  #
  # In other words, Rails::Application is Singleton and whenever you are accessing
  # Rails::Application.config or YourApplication::Application.config, you are actually
  # accessing YourApplication::Application.instance.config.
  #
  # == Initialization
  #
  # Rails::Application is responsible for executing all railties, engines and plugin
  # initializers. Besides, it also executed some bootstrap initializers (check
  # Rails::Application::Bootstrap) and finishing initializers, after all the others
  # are executed (check Rails::Application::Finisher).
  #
  # == Configuration
  #
  # Besides providing the same configuration as Rails::Engine and Rails::Railtie,
  # the application object has several specific configurations, for example
  # "allow_concurrency", "cache_classes", "consider_all_requests_local", "filter_parameters",
  # "logger", "reload_engines", "reload_plugins" and so forth.
  #
  # Check Rails::Application::Configuration to see them all.
  #
  # == Routes
  #
  # The application object is also responsible for holding the routes and reloading routes
  # whenever the files change in development.
  #
  # == Middlewares
  #
  # The Application is also responsible for building the middleware stack.
  #
  class Application < Engine
    autoload :Bootstrap,      'rails/application/bootstrap'
    autoload :Configurable,   'rails/application/configurable'
    autoload :Configuration,  'rails/application/configuration'
    autoload :Finisher,       'rails/application/finisher'
    autoload :Railties,       'rails/application/railties'
    autoload :RoutesReloader, 'rails/application/routes_reloader'

    class << self
      private :new

      def configure(&block)
        class_eval(&block)
      end

      def instance
        if self == Rails::Application
          Rails.application
        else
          @@instance ||= new
        end
      end

      def inherited(base)
        raise "You cannot have more than one Rails::Application" if Rails.application
        super
        Rails.application = base.instance
        Rails.application.add_lib_to_load_paths!
        ActiveSupport.run_load_hooks(:before_configuration, base.instance)
      end

      def respond_to?(*args)
        super || instance.respond_to?(*args)
      end

    protected

      def method_missing(*args, &block)
        instance.send(*args, &block)
      end
    end

    delegate :middleware, :to => :config

    def add_lib_to_load_paths!
      path = config.root.join('lib').to_s
      $LOAD_PATH.unshift(path) if File.exists?(path)
    end

    def require_environment!
      environment = paths.config.environment.to_a.first
      require environment if environment
    end

    def eager_load!
      railties.all(&:eager_load!)
      super
    end

    def routes
      @routes ||= ActionDispatch::Routing::RouteSet.new
    end

    def railties
      @railties ||= Railties.new(config)
    end

    def routes_reloader
      @routes_reloader ||= RoutesReloader.new
    end

    def reload_routes!
      routes_reloader.reload!
    end

    def initialize!
      run_initializers(self)
      self
    end

    def load_tasks
      initialize_tasks
      railties.all { |r| r.load_tasks }
      super
      self
    end

    def load_generators
      initialize_generators
      railties.all { |r| r.load_generators }
      super
      self
    end

    def app
      @app ||= begin
        config.middleware = config.middleware.merge_into(default_middleware_stack)
        config.middleware.build(routes)
      end
    end

    def call(env)
      app.call(env.reverse_merge!(env_defaults))
    end

    def env_defaults
      @env_defaults ||= {
        "action_dispatch.parameter_filter" => config.filter_parameters,
        "action_dispatch.secret_token" => config.secret_token
      }
    end

    def initializers
      initializers = Bootstrap.initializers_for(self)
      railties.all { |r| initializers += r.initializers }
      initializers += super
      initializers += Finisher.initializers_for(self)
      initializers
    end

  protected

    def default_middleware_stack
      ActionDispatch::MiddlewareStack.new.tap do |middleware|
        middleware.use ::ActionDispatch::Static, paths.public.to_a.first if config.serve_static_assets
        middleware.use ::Rack::Lock if !config.allow_concurrency
        middleware.use ::Rack::Runtime
        middleware.use ::Rails::Rack::Logger
        middleware.use ::ActionDispatch::ShowExceptions, config.consider_all_requests_local if config.action_dispatch.show_exceptions
        middleware.use ::ActionDispatch::RemoteIp, config.action_dispatch.ip_spoofing_check, config.action_dispatch.trusted_proxies
        middleware.use ::Rack::Sendfile, config.action_dispatch.x_sendfile_header
        middleware.use ::ActionDispatch::Callbacks, !config.cache_classes
        middleware.use ::ActionDispatch::Cookies

        if config.session_store
          middleware.use config.session_store, config.session_options
          middleware.use ::ActionDispatch::Flash
        end

        middleware.use ::ActionDispatch::ParamsParser
        middleware.use ::Rack::MethodOverride
        middleware.use ::ActionDispatch::Head
      end
    end

    def initialize_tasks
      require "rails/tasks"
      task :environment do
        $rails_rake_task = true
        require_environment!
      end
    end

    def initialize_generators
      require "rails/generators"
    end

    # Application is always reloadable when config.cache_classes is false.
    def reloadable?(app)
      true
    end
  end
end
