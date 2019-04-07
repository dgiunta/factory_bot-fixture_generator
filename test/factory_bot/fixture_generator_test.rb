require "test_helper"

describe "FactoryBot::FixtureGenerator" do
  it "skips non-active-record factories" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:human)

    expect(recorder.identities_for(:human)).must_be_nil
    expect(recorder.count_for(:human)).must_equal 0
  end

  it "loads factories" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal, name: "Bob")

    expect(recorder.identities_for(:animal).length).must_equal 2
    expect(recorder.count_for(:animal)).must_equal 2

    expect(recorder.identities_for(:animal, name: "Bob").length).must_equal 1
    expect(recorder.count_for(:animal, name: "Bob")).must_equal 1
  end

  it "resets counts" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal, name: "Bob")
    FactoryBot.create(:animal, name: "Joe")

    expect(recorder.identities_for(:animal).length).must_equal 3
    expect(recorder.count_for(:animal)).must_equal 3

    expect(recorder.identities_for(:animal, name: "Bob").length).must_equal 1
    expect(recorder.count_for(:animal, name: "Bob")).must_equal 1

    expect(recorder.identities_for(:animal, name: "Joe").length).must_equal 1
    expect(recorder.count_for(:animal, name: "Joe")).must_equal 1
  end

  it "reuses preloaded data" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    recorder.identity_map[recorder.key_for(:animal)] = [
      pre_animal_1 = Animal.create(name: "Bear"),
      pre_animal_2 = Animal.create(name: "Bear")
    ]
    recorder.identity_map[recorder.key_for(:animal, name: "Bob")] = [
      pre_bob_1 = Animal.create(name: "Bob"),
      pre_bob_2 = Animal.create(name: "Bob")
    ]

    FactoryBot::FixtureGenerator.recorder = recorder

    expect(FactoryBot.create(:animal)).must_equal pre_animal_1
    expect(FactoryBot.create(:animal)).must_equal pre_animal_2
    expect(FactoryBot.create(:animal, name: "Bob")).must_equal pre_bob_1
    expect(FactoryBot.create(:animal, name: "Bob")).must_equal pre_bob_2

    new_animal = FactoryBot.create(:animal)
    expect(recorder.identities_for(:animal).last).must_equal new_animal
  end
end
