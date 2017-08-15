module Mockie
  class ExpectationFailed < StandardError; end

  module TestHelpers
    def allow(object)
      Mockie.stub_targets[object.object_id] ||= StubTarget.new(object)
    end

    def expect(object)
      MockTarget.new(object)
    end

    def receive(message)
      StubDefinition.new(message)
    end
  end

  def self.stub_targets
    @stub_targets ||= {}
  end

  def self.mocks
    @mocks ||= []
  end

  def self.verify
    mocks.each(&:verify)
  end

  class StubTarget
    def initialize(object)
      @object = object
      @definitions = []
      @was_called = false
    end

    def to(definition)
      @definitions << definition
      local_definitions = @definitions

      @object.define_singleton_method(definition.message) do |*args|
        matching_definition = local_definitions.find do |d|
          d.message == definition.message && d.args == args
        end

        matching_definition.call if matching_definition
      end
    end
  end

  class MockTarget < StubTarget
    def to(definition)
      Mockie.mocks << definition
      super
    end
  end

  class StubDefinition
    attr_reader :message, :return_value, :args

    def initialize(message)
      @message = message
      @args = []
    end

    def and_return(value)
      @return_value = value
      self
    end

    def with(*args)
      @args = args
      self
    end

    def call
      @was_called = true
      @return_value
    end

    def verify
      raise ExpectationFailed unless @was_called
    end
  end
end
