require 'test_helper'

describe "FactoryBot::FixtureGenerator::Recorder" do
  it "works with create_list" do
    FactoryBot.create_list(:animal, 3, name: "listical")
    expect(recorder.identities_for(:animal, name: "listical").length).must_equal 3
  end

  it "works with nested create_list with default count" do
    kingdom = FactoryBot.create(:kingdom, with_animals: true)
    expect(recorder.identities_for(:kingdom, with_animals: true).length).must_equal 1
    # default animal count is 5
    expect(recorder.identities_for(:animal, kingdom: kingdom).length).must_equal 5
  end
end
