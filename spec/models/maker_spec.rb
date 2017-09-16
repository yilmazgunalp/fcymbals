require "rails_helper"



RSpec.describe Maker do
  it "has none to begin with" do
    expect(Maker.count).to eq 0
  end

  it "has one after adding one" do
    Maker.create
    expect(Maker.count).to eq 1
  end

  it "has one after one was created in a previous example" do
    expect(Maker.count).to eq 0
  end

  after(:all) { Maker.destroy_all }
end