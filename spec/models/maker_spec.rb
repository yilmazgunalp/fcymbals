require "rails_helper"



RSpec.describe Maker do
  it "has none to begin with" do
    expect(Maker.count).to eq 0
  end

    it "has none after one was created in a previous example" do
    expect(Maker.count).to eq 0
  end

end