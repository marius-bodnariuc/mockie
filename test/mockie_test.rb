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

  def test_mockie_allows_object_to_receive_message_with_params_and_return_value
    repo = Object.new

    john = {id: 1, name: "John Doe"}
    jane = {id: 2, name: "Jane Doe"}

    allow(repo).to receive(:get).with(1).and_return(john)
    allow(repo).to receive(:get).with(2).and_return(jane)

    assert_equal(john, repo.get(1))
    assert_equal(jane, repo.get(2))
  end

  # DONE with stubbing

  def test_mockie_throws_when_an_object_does_not_receive_an_expected_message
    repo = Object.new

    expect(repo).to receive(:get_all)

    assert_raise(Mockie::ExpectationFailed) { Mockie.verify }
  end

  def test_mockie_does_not_throw_when_an_object_receives_an_expected_message
    repo = Object.new

    expect(repo).to receive(:get_all)
    repo.get_all

    assert_nothing_thrown { Mockie.verify }
  end

  def test_mockie_throws_when_an_object_does_not_receive_a_message_with_expected_arguments
    repo = Object.new

    expect(repo).to receive(:get).with(1)
    repo.get(2)

    assert_raise(Mockie::ExpectationFailed) { Mockie.verify }
  end

  def test_mockie_does_not_throw_when_an_object_receives_a_message_with_expected_arguments
    repo = Object.new
    john = {id: 1, name: "John Doe"}

    expect(repo).to receive(:get).with(1)
    repo.get(1)

    assert_nothing_thrown { Mockie.verify }
  end

  def test_mockie_allows_return_values_by_arguments_from_mocks
    repo = Object.new
    john = {id: 1, name: "John Doe"}

    expect(repo).to receive(:get).with(1).and_return(john)

    assert_equal(john, repo.get(1))
    assert_nothing_thrown { Mockie.verify }
  end
end
