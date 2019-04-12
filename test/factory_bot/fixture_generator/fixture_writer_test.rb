require "test_helper"

describe "FactoryBot::FixtureGenerator::FixtureWriter" do
  it "generates a list of FactoryBot create statements" do
    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal, name: "Bob")
    FactoryBot.create(:animal, name: "Joe")

    writer = FactoryBot::FixtureGenerator::FixtureWriter.new(recorder)
    animal_key = recorder.key_for(:animal)
    bob_animal_key = recorder.key_for(:animal, name: "Bob")
    joe_animal_key = recorder.key_for(:animal, name: "Joe")

    expect(writer.recorded_factories).must_equal %Q{
      _animal_#{animal_key}_0 = FactoryBot.create(:animal)
      _animal_#{animal_key}_1 = FactoryBot.create(:animal)
      _animal_#{animal_key}_2 = FactoryBot.create(:animal)
      _animal_#{bob_animal_key}_0 = FactoryBot.create(:animal, {:name=>"Bob"})
      _animal_#{joe_animal_key}_0 = FactoryBot.create(:animal, {:name=>"Joe"})
    }.gsub(/^ +/, "").split(/\n/).reject(&:blank?).join("\n")
  end

  it "properly saves references to other created factories" do
    kingdom = FactoryBot.create(:kingdom, name: "Awesome")
    FactoryBot.create(:animal, name: "Awesome Animal", kingdom: kingdom)

    writer = FactoryBot::FixtureGenerator::FixtureWriter.new(recorder)
    kingdom_key = recorder.key_for(:kingdom, name: "Awesome")
    animal_key = recorder.key_for(:animal, name: "Awesome Animal", kingdom: kingdom)

    expect(writer.recorded_factories).must_equal %Q{
      _kingdom_#{kingdom_key}_0 = FactoryBot.create(:kingdom, {:name=>"Awesome"})
      _animal_#{animal_key}_0 = FactoryBot.create(:animal, {:name=>"Awesome Animal", :kingdom=>_kingdom_#{kingdom_key}_0})
    }.gsub(/^ +/, "").split(/\n/).reject(&:blank?).join("\n")
  end
end
