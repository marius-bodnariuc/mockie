require 'test/unit'
require_relative '../lib/mockie.rb'

class MockieTest < Test::Unit::TestCase
  include Mockie::TestHelpers

  def test_mockie_allows_object_to_receive_message
    repo = Object.new

    allow(repo).to receive(:get_all)

    assert_true(repo.respond_to?(:get_all))
  end

  def test_mockie_allows_object_to_receive_message_and_return_value
    repo = Object.new
    people = [{id: 1, name: "John Doe"}, {id: 2, name: "Jane Doe"}]

    allow(repo).to receive(:get_all).and_return(people)

    assert_equal(people, repo.get_all)
  end
end
