module Mockie
  module TestHelpers
    def allow(object)
      StubTarget.new(object)
    end

    def receive(message)
      StubDefinition.new(message)
    end
  end

  class StubTarget
    def initialize(object)
      @object = object
    end

    def to(definition)
      @object.define_singleton_method(definition.message) do
      end
    end
  end

  class StubDefinition
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end
end
