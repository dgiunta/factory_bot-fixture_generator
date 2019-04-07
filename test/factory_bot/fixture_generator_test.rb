require "test_helper"

describe "FactoryBot::FixtureGenerator" do
  it "skips non-active-record factories" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:human)

    recorder.identities_for(:human).must_be_nil
    recorder.count_for(:human).must_equal 0
  end

  it "loads factories" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal, name: "Bob")

    recorder.identities_for(:animal).length.must_equal 2
    recorder.count_for(:animal).must_equal 2

    recorder.identities_for(:animal, name: "Bob").length.must_equal 1
    recorder.count_for(:animal, name: "Bob").must_equal 1
  end

  it "resets counts" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal, name: "Bob")
    FactoryBot.create(:animal, name: "Joe")

    recorder.identities_for(:animal).length.must_equal 3
    recorder.count_for(:animal).must_equal 3

    recorder.identities_for(:animal, name: "Bob").length.must_equal 1
    recorder.count_for(:animal, name: "Bob").must_equal 1

    recorder.identities_for(:animal, name: "Joe").length.must_equal 1
    recorder.count_for(:animal, name: "Joe").must_equal 1
  end

  it "reuses preloaded data" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    recorder.send(:identity_map)[recorder.key_for(:animal)] = [
      pre_animal_1 = Animal.create(name: "Bear"),
      pre_animal_2 = Animal.create(name: "Bear")
    ]
    recorder.send(:identity_map)[recorder.key_for(:animal, name: "Bob")] = [
      pre_bob_1 = Animal.create(name: "Bob"),
      pre_bob_2 = Animal.create(name: "Bob")
    ]

    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:animal).must_equal pre_animal_1
    FactoryBot.create(:animal).must_equal pre_animal_2
    FactoryBot.create(:animal, name: "Bob").must_equal pre_bob_1
    FactoryBot.create(:animal, name: "Bob").must_equal pre_bob_2

    new_animal = FactoryBot.create(:animal)
    recorder.identities_for(:animal).last.must_equal new_animal
  end
end
