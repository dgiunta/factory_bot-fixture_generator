require "test_helper"

describe "FactoryBot::FixtureGenerator::FixtureWriter" do
  it "generates a list of FactoryBot create statements" do
    recorder = FactoryBot::FixtureGenerator::Recorder.new
    FactoryBot::FixtureGenerator.recorder = recorder

    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal)
    FactoryBot.create(:animal, name: "Bob")
    FactoryBot.create(:animal, name: "Joe")

    writer = FactoryBot::FixtureGenerator::FixtureWriter.new(recorder)
    expect(writer.to_s).must_equal %q{
      FactoryBot.create(:animal)
      FactoryBot.create(:animal)
      FactoryBot.create(:animal)
      FactoryBot.create(:animal, {:name=>"Bob"})
      FactoryBot.create(:animal, {:name=>"Joe"})
    }.gsub(/^ +/, "").split(/\n/).reject(&:blank?)
  end
end
